#!/usr/bin/env bash
#
# Interactive picker for adding GitHub repos as project markdown files.
# Lists your public, non-fork, non-archived repos via `gh`, lets you
# multi-select with fzf, and writes one .md per pick into src/_projects/.
#
# Deps: gh (authenticated), jq, fzf.
# Usage: bin/add-projects (or `bash scripts/add-projects-from-github.sh`).

set -euo pipefail

for cmd in gh jq fzf; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "error: '$cmd' is required but not installed." >&2
    exit 1
  fi
done

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECTS_DIR="$ROOT_DIR/src/_projects"
mkdir -p "$PROJECTS_DIR"

OWNER="${GITHUB_OWNER:-$(gh api user --jq .login)}"

# Fetch up to 100 repos with the metadata we need. Filter out forks and
# archived in jq so the picker only shows real candidates.
REPOS_JSON="$(
  gh repo list "$OWNER" \
    --limit 100 \
    --visibility public \
    --json name,description,url,primaryLanguage,stargazerCount,forkCount,updatedAt,isFork,isArchived \
  | jq '[ .[] | select(.isFork == false and .isArchived == false) ]'
)"

if [ "$(jq 'length' <<<"$REPOS_JSON")" -eq 0 ]; then
  echo "No matching repos found for $OWNER." >&2
  exit 1
fi

# fzf input: one tab-delimited line per repo. The leading visible column
# is the repo name and short description so the picker reads well.
PICKED="$(
  jq -r '
    sort_by(.updatedAt) | reverse |
    .[] | [
      .name,
      (.description // ""),
      .url,
      (.primaryLanguage.name // ""),
      (.stargazerCount | tostring),
      (.forkCount | tostring),
      .updatedAt
    ] | @tsv
  ' <<<"$REPOS_JSON" \
  | fzf --multi \
        --prompt="repos> " \
        --header="tab to select, enter to confirm" \
        --delimiter="\t" \
        --with-nth=1,2,7 \
        --preview-window="right:50%:wrap" \
        --preview='echo {} | awk -F"\t" "{ printf \"name:   %s\\nstars:  %s  forks: %s\\nlang:   %s\\nupdated: %s\\n\\n%s\\n\\n%s\\n\", \$1, \$5, \$6, \$4, \$7, \$3, \$2 }"' \
  || true
)"

if [ -z "$PICKED" ]; then
  echo "Nothing picked."
  exit 0
fi

# Map a language name → the GitHub linguist color we render on the card.
lang_color() {
  case "$1" in
    Ruby) echo "#701516" ;;
    JavaScript) echo "#f1e05a" ;;
    TypeScript) echo "#3178c6" ;;
    HTML) echo "#e34c26" ;;
    CSS) echo "#563d7c" ;;
    Shell) echo "#89e051" ;;
    Dockerfile) echo "#384d54" ;;
    Python) echo "#3572A5" ;;
    Go) echo "#00ADD8" ;;
    Rust) echo "#dea584" ;;
    Elixir) echo "#6e4a7e" ;;
    Crystal) echo "#000100" ;;
    *) echo "#7c8481" ;;
  esac
}

# Convert a repo name into a kebab-case filename slug.
slugify() {
  printf '%s' "$1" | tr 'A-Z' 'a-z' | tr '_.' '--' | tr -cd 'a-z0-9-' | tr -s '-'
}

created=0
skipped=0
TODAY="$(date +%F)"

while IFS=$'\t' read -r name desc url lang stars forks _updated; do
  [ -z "$name" ] && continue

  slug="$(slugify "$name")"
  file="$PROJECTS_DIR/$slug.md"

  if [ -e "$file" ]; then
    echo "skip: $slug.md already exists"
    skipped=$((skipped + 1))
    continue
  fi

  color="$(lang_color "$lang")"
  desc_yaml="${desc//\"/\\\"}"

  {
    printf -- "---\n"
    printf 'title: %s\n' "$name"
    printf 'description: "%s"\n' "$desc_yaml"
    printf 'date: %s\n' "$TODAY"
    printf 'repo: %s\n' "$url"
    [ -n "$lang" ] && printf 'lang: %s\n' "$lang"
    printf 'lang_color: "%s"\n' "$color"
    printf 'stars: %s\n' "$stars"
    printf 'forks: %s\n' "$forks"
    printf -- "---\n"
  } >"$file"

  echo "added: $slug.md"
  created=$((created + 1))
done <<<"$PICKED"

echo
echo "done — created: $created, skipped: $skipped"
