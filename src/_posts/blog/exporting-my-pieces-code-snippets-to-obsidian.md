---
title: Exporting my Pieces code snippets to Obsidian
description: Pieces put memories behind a paid plan, so I pulled 358 saved snippets out of its local API and turned them into plain Markdown I own.
tags:
  - obsidian
  - ruby
  - markdown
  - tooling
date: 2026-08-14 00:00:00.000000000 Z
categories:
  - tutorials
---

I opened Pieces today and was greeted with this message:

> After Sunday, August 16, 2026 at 11:59:59 PM UTC, creating new memories, generating workstream summaries, and using Agentic Chats will require a paid plan. You can still read, browse, and query your existing memories and chats in Pieces and through MCP. You do not need a paid plan for that access. As of August 10, 2026, your Pieces history includes 200K+ memories across 20 months. Thank you for making Pieces part of your work. We don't take that trust, or this change, lightly. Long-term context and Agentic Chats have ongoing infrastructure costs. Paid plans let us keep those services reliable and continue improving Pieces. We understand that paying for capabilities that were free may be disappointing.

I have used Pieces for the past few years to save code snippets I wanted to reference later. I don't use enough of the other functionality to justify adding another subscription, so my first reaction was pretty simple: uninstall it.

There was just one problem.

I had **358 code snippets** saved in Pieces, some dating back almost three years, and I didn't want uninstalling the app to mean losing them.

Since I already keep the rest of my notes in Obsidian, Markdown seemed like the obvious destination.

## Finding the Data

My first thought was to use the Pieces CLI.

Unfortunately, while the CLI can list materials, it doesn't currently provide a convenient machine-readable bulk export command.

PiecesOS was already running locally on my Mac, though, and in my case it was listening on port `39300`.

It turns out we could grab all of my saved assets directly:

```bash
curl -fsS http://localhost:39300/assets -o ./tmp/pieces-assets.json
```

That gave me a single JSON snapshot containing all **358** of my saved materials.

At this point I technically had a backup, which was the most important part. Even if the rest of the migration went terribly wrong, I now had the original data outside of Pieces.

## Understanding the Export

The JSON was a little more complicated than I expected.

Most snippets stored their original contents here:

```text
original.reference.fragment.string.raw
```

But one of my 358 snippets stored its contents as an array of bytes instead:

```text
original.reference.file.bytes.raw
```

So the migration script needed to support both formats.

Before writing anything to my Obsidian vault, I spent some time validating the export rather than assuming the API response was consistent.

A few things we found:

- All 358 assets had unique Pieces IDs.
- All 358 snippets were recoverable.
- All snippet contents were valid UTF-8.
- 357 snippets stored their contents as strings.
- 1 snippet stored its contents as bytes.
- 65 snippets ended with a newline.
- 293 did not.
- 40 snippets contained triple backticks.
- Several snippets shared the same title.
- Some snippets had completely identical contents but different metadata.

I decided **not to deduplicate anything**.

If Pieces thought I had 358 saved materials, I wanted 358 Markdown files when the migration finished.

## Pieces Metadata Was... Interesting

Pieces stores quite a bit more than the snippet itself.

There were descriptions, tags, websites, classifications, commit messages, timestamps, and other generated metadata attached to the assets.

Initially I thought I would preserve most of that in the resulting Markdown files.

After actually inspecting it, I changed my mind.

For example, Pieces had generated descriptions like:

> The code snippet below calculates the factorial of a given number using recursion.

For a snippet named `Database Query Optimization Strategies`.

Other descriptions were truncated, inaccurate, or clearly generated from unrelated context.

Tags had similar problems. There were over 6,000 tag relationships, but almost all of them had been generated automatically.

Some examples included things like:

```text
Framework: Sorry, but I can't generate a response based on the given code snippet
```

and:

```text
Pages related to {{value:Link}}...
```

That is not metadata I particularly want permanently attached to my Obsidian notes.

So I ended up being fairly conservative about what made it into the human-readable files.

## What I Kept

Each generated note contains a small amount of frontmatter:

```yaml
---
type: snippet
source: "[[Pieces.app]]"
language: shell
created_on: 2023-11-21
updated_on: 2023-11-21
---
```

If I had manually added tags in Pieces, those are included too:

```yaml
---
type: snippet
source: "[[Pieces.app]]"
language: javascript
created_on: 2024-09-19
updated_on: 2024-09-19
tags:
  - obsidian
  - quickadd
---
```

Only **7 tags across 5 snippets** turned out to be explicitly manual tags.

I also kept a `source_url` when Pieces had a trustworthy original source URL.

There were quite a few website relationships in the export, but most were automatically generated "Relevant Site" links. Some were Google searches, GitHub tag pages, temporary Raindrop cache URLs, or even JavaScript chunks from websites.

After filtering those out, only **20 of the 358 snippets** had a source URL that I felt was worth including.

## What I Didn't Keep

I deliberately left these out of the Markdown files:

- Pieces IDs
- generated descriptions
- generated tags
- generated website associations
- generated Git commit messages
- other Pieces-specific enrichment

I still preserve all of this information in the raw JSON export and a normalized JSONL archive.

That means nothing is actually lost, but my Obsidian notes don't inherit years of questionable generated metadata.

There was one exception.

One snippet had an explanation I had manually written inside Pieces:

> The picker template when run will check if the note you've created was created in the default location...

That was clearly useful context I had authored myself, so the exporter keeps manual explanations in an optional `## Explanation` section.

## Fixing Language Detection

Pieces also wasn't always correct about programming languages.

For example, this:

```bash
mdfind kMDItemAppStoreHasReceipt=1
```

was classified as `BatchFile`.

That might technically fall into Pieces' idea of command-line code, but it definitely isn't a Windows batch file.

Since I want Obsidian's syntax highlighting to work correctly, the migration script includes a small correction layer.

If Pieces reports `BatchFile` but the contents contain obvious Unix shell commands or syntax such as `brew`, `git`, `curl`, `grep`, `mdfind`, environment variables, pipes, or shell conditionals, I treat it as shell instead. I did the same for GraphQL, AppleScript, and a few other languages.

There were also 13 particularly strange classifications that were easier to correct explicitly after inspecting them.

## Handling Markdown Code Fences

This was another edge case I almost missed.

Forty of my snippets contained triple backticks themselves.

If I blindly generated this:

`````markdown
````markdown
some markdown containing ```
````
`````

`````

I could accidentally terminate the outer code block.

Instead, the exporter determines the longest consecutive run of backticks inside each snippet and uses a fence at least one character longer.

So a snippet containing:

````markdown
```

```
`````

might be wrapped in:

````markdown
```
...
```
````

It is a small detail, but exactly the kind of thing that can silently corrupt a bulk Markdown migration.

## Duplicate Titles

Pieces allows multiple snippets to have the same name.

I had 16 groups of duplicate names, including:

- `Rails routes fuzzy finder`
- `Git file search and run Ruby test`
- `Generate Obsidian Plugin Metadata Files`
- `Remove processed tag from active Markdown file`

For unique titles, I use the title directly:

```text
Find All Apps Installed from App Store.md
```

If multiple snippets resolve to the same filename, **all** members of the collision group get part of their Pieces ID appended:

```text
Rails routes fuzzy finder--fa3b8c22.md
Rails routes fuzzy finder--7db5e524.md
```

I didn't want the filename chosen for one duplicate to depend on whichever asset happened to appear first in the JSON.

The filenames should be deterministic every time the exporter runs.

## The Result

A generated note looks roughly like this:

````bash
---
type: snippet
source: "[[Pieces.app]]"
language: shell
created_on: 2023-11-21
updated_on: 2023-11-21
---

## Code

```bash
mdfind kMDItemAppStoreHasReceipt=1
```
````

Pretty boring.

That's exactly what I wanted.

My snippets are now plain Markdown files that I can search, edit, link, version with Git, process with Ruby, query from Obsidian, or move somewhere else entirely later.

There is no special application required to read them.

## Keeping the Original Export

I didn't want the conversion to Markdown to become the new source of truth immediately, so the exporter produces a few different artifacts:

```text
pieces-export/
├── raw/
│   └── assets.json
├── normalized/
│   └── assets.jsonl
├── markdown/
│   └── ...
└── manifest.json
```

`raw/assets.json` is the untouched response from PiecesOS.

`normalized/assets.jsonl` contains a more convenient representation of the data, including metadata that I intentionally left out of Obsidian.

`manifest.json` maps every Pieces asset to its Markdown filename and includes hashes of the original contents.

That gives me something I can use to verify the migration instead of looking at a folder with 358 files and hoping everything worked.

## Why I Went This Route

I could have just copied the visible snippet contents out of Pieces and called it a day.

But bulk migrations are exactly where small inconsistencies become annoying later.

I wanted to know that:

- every Pieces asset produced a Markdown file
- every original snippet was preserved exactly
- duplicate titles didn't overwrite each other
- metadata filtering was intentional
- rerunning the exporter produced the same filenames
- I still had the untouched source data if I discovered a bug

The most important part of the entire process was probably the first command:

```bash
curl -fsS http://localhost:39300/assets -o ./tmp/pieces-assets.json
```

Once I had that file, Pieces was no longer the only place containing my snippets.

Everything after that was just transformation.

## Finished Script

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "digest"
require "fileutils"
require "json"
require "optparse"
require "securerandom"
require "time"

EXPECTED_ASSET_COUNT = 358

REAL_LUA_ASSET_ID = "eb6ef70c-fd33-47a1-967e-7c6e246384f6"

LANGUAGE_OVERRIDES = {
  "c379d282-ca8b-493e-a4df-fa010ebc3797" => "javascript",
  "c8ecd0c3-693e-4026-8698-8185e20c4d0b" => "bash",
  "f943f133-cb73-4b47-a5c3-0078712906bf" => "json",
  "93cf8228-2aae-4691-8525-f6e37cecd189" => "yaml",
  "34d06144-5932-47b0-b00d-3e55b9ea8d19" => "markdown",
  "e46af71d-21f2-49b5-bc02-4b5021fd0681" => "zsh",
  "1f8a754f-e5ec-418b-b4b2-92bd24aa8798" => "shell",
  "0af3ccde-f9c3-409b-8171-2f01db9b869e" => "shell",
  "cddeb072-f13d-4b7b-94a9-1a1e8c480775" => "bash",
  "51c77565-8545-4ce7-86b9-476c962a7376" => "bash",
  "64cb2e46-129e-44b5-af47-deb67bc4870b" => "json",
  "12f44507-75ae-48a1-aada-77c75e9b4814" => "graphql",
  "d16236f4-5d05-4fc5-8465-4df119a7d0b3" => "graphql"
}.freeze

ANALYSIS_LANGUAGE_MAP = {
  "ASP" => "asp",
  "BatchFile" => "batch",
  "CSS" => "css",
  "CoffeeScript" => "coffeescript",
  "Elixir" => "elixir",
  "Groovy" => "groovy",
  "HTML" => "html",
  "JSON" => "json",
  "JavaScript" => "javascript",
  "Lua" => "lua",
  "Markdown" => "markdown",
  "Perl" => "perl",
  "Python" => "python",
  "R" => "r",
  "Ruby" => "ruby",
  "SQL" => "sql",
  "Shell" => "shell",
  "TEX" => "tex",
  "TOML" => "toml",
  "TypeScript" => "typescript",
  "YAML" => "yaml"
}.freeze

CLASSIFICATION_LANGUAGE_MAP = {
  "asp" => "asp",
  "bat" => "batch",
  "bash" => "bash",
  "coffee" => "coffeescript",
  "css" => "css",
  "graphql" => "graphql",
  "groovy" => "groovy",
  "html" => "html",
  "js" => "javascript",
  "json" => "json",
  "lua" => "lua",
  "md" => "markdown",
  "pl" => "perl",
  "py" => "python",
  "r" => "r",
  "rb" => "ruby",
  "sh" => "shell",
  "sql" => "sql",
  "tex" => "tex",
  "toml" => "toml",
  "ts" => "typescript",
  "yaml" => "yaml",
  "yml" => "yaml",
  "zsh" => "zsh"
}.freeze

FENCE_LANGUAGE_MAP = {
  "applescript" => "applescript",
  "asp" => "asp",
  "bash" => "bash",
  "batch" => "batch",
  "coffeescript" => "coffeescript",
  "css" => "css",
  "elixir" => "elixir",
  "graphql" => "graphql",
  "groovy" => "groovy",
  "html" => "html",
  "javascript" => "javascript",
  "json" => "json",
  "lua" => "lua",
  "markdown" => "markdown",
  "perl" => "perl",
  "python" => "python",
  "r" => "r",
  "ruby" => "ruby",
  "shell" => "bash",
  "sql" => "sql",
  "tex" => "tex",
  "toml" => "toml",
  "typescript" => "typescript",
  "yaml" => "yaml",
  "zsh" => "zsh"
}.freeze

KNOWN_CONTROL_CHARACTERS = {
  "c379d282-ca8b-493e-a4df-fa010ebc3797" => [0x07, 0x1B]
}.freeze

options = {
  input: "./tmp/pieces-assets.json",
  output: "./snippets",
  force: false
}

OptionParser.new do |parser|
  parser.banner = "Usage: ruby migrate_pieces_to_obsidian.rb [options]"

  parser.on("-i", "--input PATH", "Pieces assets.json snapshot") do |path|
    options[:input] = path
  end

  parser.on("-o", "--output PATH", "Output directory") do |path|
    options[:output] = path
  end

  parser.on("-f", "--force", "Replace an existing output directory") do
    options[:force] = true
  end
end.parse!

input_path = File.expand_path(options[:input])
output_path = File.expand_path(options[:output])

abort "Input does not exist: #{input_path}" unless File.file?(input_path)

if File.exist?(output_path) && !options[:force]
  abort <<~MESSAGE
    Output already exists: #{output_path}
    Re-run with --force to replace it.
  MESSAGE
end

def extract_body(asset)
  raw = asset.dig("original", "reference", "fragment", "string", "raw")

  if raw.is_a?(String)
    return [raw.dup.force_encoding(Encoding::UTF_8), "string"]
  end

  bytes = asset.dig("original", "reference", "file", "bytes", "raw")

  if bytes.is_a?(Array)
    unless bytes.all? { |byte| byte.is_a?(Integer) && byte.between?(0, 255) }
      raise "Invalid byte array for asset #{asset.fetch("id")}"
    end

    return [
      bytes.pack("C*").force_encoding(Encoding::UTF_8),
      "file_bytes"
    ]
  end

  raise "Unsupported body storage for asset #{asset.fetch("id")}"
end

def validate_body!(asset, body)
  id = asset.fetch("id")

  raise "Invalid UTF-8 in asset #{id}" unless body.valid_encoding?

  if body.bytes.first(3) == [0xEF, 0xBB, 0xBF]
    raise "Unexpected UTF-8 BOM in asset #{id}"
  end

  controls = body.codepoints.select do |codepoint|
    (codepoint < 0x20 && ![0x09, 0x0A, 0x0D].include?(codepoint)) ||
      codepoint == 0x7F
  end

  allowed = KNOWN_CONTROL_CHARACTERS.fetch(id, [])
  unexpected = controls.uniq - allowed

  return if unexpected.empty?

  formatted = unexpected.map { |cp| "U+%04X" % cp }.join(", ")

  raise "Unexpected control characters in asset #{id}: #{formatted}"
end

def source_timestamp(asset, key)
  value = asset.dig(key, "value")

  unless value.is_a?(String)
    raise "Missing #{key}.value for asset #{asset.fetch("id")}"
  end

  Time.iso8601(value)
  value
end

def analysis_language(asset)
  asset.dig("original", "reference", "analysis", "code", "language") ||
    asset.dig("original", "analysis", "code", "language") ||
    asset.dig("analysis", "code", "language")
end

def classification_language(asset)
  asset.dig("original", "reference", "classification", "specific") ||
    asset.dig("original", "classification", "specific") ||
    asset.dig("classification", "specific")
end

def shell_like?(body)
  patterns = [
    /\A\s*#!/,
    /\b(?:mdfind|mdls|defaults|osascript|plutil|brew|git|gh|curl|wget|grep|sed|awk|find|fd|fzf|xargs|open|launchctl|pg_ctl)\b/,
    /\b(?:if|then|elif|fi|for|while|until|do|done|case|esac|function)\b/,
    /\$\{?[A-Za-z_][A-Za-z0-9_]*\}?/,
    /(?:&&|\|\|)/,
    /\|\s*[A-Za-z_][A-Za-z0-9_-]*/
  ]

  patterns.any? { |pattern| body.match?(pattern) }
end

def normalize_language(asset, language)
  case language
  when "asp"
    "markdown"
  when "groovy"
    "graphql"
  when "tex"
    "shell"
  when "lua"
    asset.fetch("id") == REAL_LUA_ASSET_ID ? "lua" : "applescript"
  else
    language
  end
end

def resolve_language(asset, body)
  id = asset.fetch("id")

  if LANGUAGE_OVERRIDES.key?(id)
    return LANGUAGE_OVERRIDES.fetch(id)
  end

  analysis = analysis_language(asset)
  specific = classification_language(asset)

  detected =
    if analysis.is_a?(String) &&
       !analysis.empty? &&
       !%w[Unknown UNKNOWN TEXT text].include?(analysis)
      ANALYSIS_LANGUAGE_MAP[analysis]
    end

  if detected.nil? &&
     specific.is_a?(String) &&
     !specific.empty? &&
     !%w[Unknown UNKNOWN TEXT text].include?(specific)
    detected = CLASSIFICATION_LANGUAGE_MAP[specific.downcase]
  end

  # Pieces sometimes identifies Unix shell snippets as Windows BatchFile.
  if detected == "batch" && shell_like?(body)
    detected = "shell"
  end

  normalize_language(asset, detected)
end

def manual_tags(asset)
  id = asset.fetch("id")

  Array(asset.dig("tags", "iterable"))
    .select do |tag|
      text = tag["text"]

      text.is_a?(String) &&
        !text.strip.empty? &&
        tag.dig("mechanisms", id) == "MANUAL"
    end
    .map { |tag| tag.fetch("text").strip }
    .uniq
end

def manual_explanation(asset)
  annotations = Array(asset.dig("annotations", "iterable"))

  candidates = annotations.select do |annotation|
    annotation["type"] == "EXPLANATION" &&
      annotation["mechanism"] == "MANUAL" &&
      annotation["text"].is_a?(String) &&
      !annotation["text"].strip.empty?
  end

  candidates.max_by do |annotation|
    annotation.dig("updated", "value") ||
      annotation.dig("created", "value") ||
      ""
  end&.fetch("text")&.strip
end

def accepted_source_url(asset)
  id = asset.fetch("id")

  Array(asset.dig("websites", "iterable"))
    .find do |website|
      url = website["url"].to_s

      website.dig("mechanisms", id) == "MANUAL" &&
        website["name"] == "Origin Website" &&
        !url.empty? &&
        !url.include?("cache.raindrop.io") &&
        !url.include?("X-Amz-Signature=") &&
        !url.include?("X-Amz-Expires=") &&
        !url.include?("/_next/static/chunks/")
    end
    &.fetch("url")
end

def sanitize_filename(name)
  value = name.to_s.unicode_normalize(:nfc)

  value = value
    # macOS / path separators plus characters Obsidian disallows.
    .gsub(/[\/:\[\]#^|]+/, " - ")
    .gsub(/[\u0000-\u001F\u007F]/, " ")
    .gsub(/\s+-\s+-\s+/, " - ")
    .gsub(/\s+/, " ")
    .strip
    .sub(/\A[.\s]+/, "")
    .sub(/[.\s]+\z/, "")

  value = "Untitled" if value.empty?
  value
end

def collision_key(filename)
  filename
    .unicode_normalize(:nfc)
    .downcase
end

def safe_fence(body)
  max_run = body.scan(/`+/).map(&:length).max || 0
  "`" * [3, max_run + 1].max
end

def yaml_string(value)
  JSON.generate(value)
end

def frontmatter(
  language:,
  tags:,
  source_url:,
  created_at:,
  updated_at:
)
  output = +"---\n"
  output << "type: snippet\n"
  output << %(source: "[[Pieces.app]]"\n)
  output << "language: #{yaml_string(language)}\n" if language
  output << "created_on: #{Date.parse(created_at)}\n"
  output << "updated_on: #{Date.parse(updated_at)}\n"

  unless tags.empty?
    output << "tags:\n"

    tags.each do |tag|
      output << "  - #{yaml_string(tag)}\n"
    end
  end

  if source_url
    output << "source_url: #{yaml_string(source_url)}\n"
  end

  output << "---\n"
  output
end

def markdown_for(
  body:,
  language:,
  tags:,
  source_url:,
  explanation:,
  created_at:,
  updated_at:
)
  markdown = +""

  markdown << frontmatter(
    language: language,
    tags: tags,
    source_url: source_url,
    created_at: created_at,
    updated_at: updated_at
  )

  if explanation
    markdown << "\n## Explanation\n\n"
    markdown << explanation
    markdown << "\n"
  end

  markdown << "\n## Code\n\n"

  fence = safe_fence(body)
  fence_language = FENCE_LANGUAGE_MAP.fetch(language, language).to_s

  markdown << fence
  markdown << fence_language unless fence_language.empty?
  markdown << "\n"
  markdown << body

  # The closing Markdown fence must begin on its own line. The manifest
  # retains whether the original Pieces body actually had a trailing newline.
  markdown << "\n" unless body.end_with?("\n")

  markdown << fence
  markdown << "\n"

  markdown
end

raw_json = File.binread(input_path)
raw_sha256 = Digest::SHA256.hexdigest(raw_json)

data = JSON.parse(raw_json)
assets = data.fetch("iterable")

unless assets.length == EXPECTED_ASSET_COUNT
  abort(
    "Expected #{EXPECTED_ASSET_COUNT} assets from the audited snapshot, " \
    "but found #{assets.length}. Re-audit before exporting."
  )
end

asset_ids = assets.map { |asset| asset.fetch("id") }

unless asset_ids.uniq.length == asset_ids.length
  abort "Duplicate Pieces asset IDs detected."
end

original_ids = assets.map { |asset| asset.dig("original", "id") }

unless original_ids.compact.uniq.length == original_ids.compact.length
  abort "Duplicate Pieces original IDs detected."
end

prepared = assets.map do |asset|
  body, storage = extract_body(asset)
  validate_body!(asset, body)

  created_at = source_timestamp(asset, "created")
  updated_at = source_timestamp(asset, "updated")

  if Time.iso8601(updated_at) < Time.iso8601(created_at)
    raise "updated < created for asset #{asset.fetch("id")}"
  end

  {
    asset: asset,
    id: asset.fetch("id"),
    original_id: asset.dig("original", "id"),
    name: asset.fetch("name"),
    basename: sanitize_filename(asset.fetch("name")),
    body: body,
    body_storage: storage,
    body_sha256: Digest::SHA256.hexdigest(body.b),
    body_bytes: body.bytesize,
    trailing_newline: body.end_with?("\n"),
    language: resolve_language(asset, body),
    raw_analysis_language: analysis_language(asset),
    raw_classification_language: classification_language(asset),
    created_at: created_at,
    updated_at: updated_at,
    tags: manual_tags(asset),
    explanation: manual_explanation(asset),
    source_url: accepted_source_url(asset)
  }
end

groups = prepared.group_by do |record|
  collision_key(record.fetch(:basename))
end

prepared.each do |record|
  colliding =
    groups.fetch(
      collision_key(record.fetch(:basename))
    ).length > 1

  record[:filename] =
    if colliding
      "#{record.fetch(:basename)}--#{record.fetch(:id)[0, 8]}.md"
    else
      "#{record.fetch(:basename)}.md"
    end
end

filenames = prepared.map do |record|
  collision_key(record.fetch(:filename))
end

unless filenames.uniq.length == filenames.length
  abort "Filename collision remains after deterministic ID suffixing."
end

temporary_path =
  "#{output_path}.tmp-#{Process.pid}-#{SecureRandom.hex(4)}"

begin
  FileUtils.rm_rf(temporary_path)

  raw_dir = File.join(temporary_path, "raw")
  normalized_dir = File.join(temporary_path, "normalized")
  markdown_dir = File.join(temporary_path, "markdown")

  FileUtils.mkdir_p(raw_dir)
  FileUtils.mkdir_p(normalized_dir)
  FileUtils.mkdir_p(markdown_dir)

  raw_output = File.join(raw_dir, "assets.json")

  File.binwrite(raw_output, raw_json)
  File.chmod(0o600, raw_output)

  normalized_path =
    File.join(normalized_dir, "assets.jsonl")

  File.open(normalized_path, "wb") do |file|
    prepared.sort_by { |record| record.fetch(:id) }.each do |record|
      asset = record.fetch(:asset)

      normalized = {
        id: record.fetch(:id),
        original_id: record[:original_id],
        name: record.fetch(:name),
        filename: record.fetch(:filename),

        body: record.fetch(:body),
        body_storage: record.fetch(:body_storage),
        body_sha256: record.fetch(:body_sha256),
        body_bytes: record.fetch(:body_bytes),
        trailing_newline: record.fetch(:trailing_newline),

        language: {
          resolved: record[:language],
          pieces_analysis: record[:raw_analysis_language],
          pieces_classification: record[:raw_classification_language]
        },

        timestamps: {
          created: record.fetch(:created_at),
          updated: record.fetch(:updated_at)
        },

        markdown_metadata: {
          tags: record.fetch(:tags),
          source_url: record[:source_url],
          explanation: record[:explanation]
        },

        annotations: Array(asset.dig("annotations", "iterable")),
        tags: Array(asset.dig("tags", "iterable")),
        websites: Array(asset.dig("websites", "iterable"))
      }

      file.write(JSON.generate(normalized))
      file.write("\n")
    end
  end

  manifest_assets = []

  prepared
    .sort_by { |record| record.fetch(:filename).downcase }
    .each do |record|
      markdown = markdown_for(
        body: record.fetch(:body),
        language: record[:language],
        tags: record.fetch(:tags),
        source_url: record[:source_url],
        explanation: record[:explanation],
        created_at: record.fetch(:created_at),
        updated_at: record.fetch(:updated_at)
      )

      markdown_path =
        File.join(markdown_dir, record.fetch(:filename))

      File.binwrite(markdown_path, markdown)

      manifest_assets << {
        id: record.fetch(:id),
        original_id: record[:original_id],
        name: record.fetch(:name),
        filename: record.fetch(:filename),

        body_storage: record.fetch(:body_storage),
        body_sha256: record.fetch(:body_sha256),
        body_bytes: record.fetch(:body_bytes),
        trailing_newline: record.fetch(:trailing_newline),

        markdown_sha256:
          Digest::SHA256.hexdigest(markdown.b),

        language: record[:language],
        pieces_analysis_language:
          record[:raw_analysis_language],
        pieces_classification_language:
          record[:raw_classification_language],

        created: record.fetch(:created_at),
        updated: record.fetch(:updated_at),

        manual_tags: record.fetch(:tags),
        explanation: record[:explanation],
        source_url: record[:source_url]
      }
    end

  markdown_count =
    Dir.glob(File.join(markdown_dir, "*.md")).length

  unless markdown_count == assets.length
    raise(
      "Expected #{assets.length} Markdown files, " \
      "created #{markdown_count}"
    )
  end

  language_counts =
    prepared
      .group_by { |record| record[:language] || "unknown" }
      .transform_values(&:length)
      .sort
      .to_h

  manifest = {
    schema_version: 2,
    generated_at: Time.now.utc.iso8601,

    source: {
      path: input_path,
      sha256: raw_sha256,
      asset_count: assets.length
    },

    output: {
      markdown_count: markdown_count,
      assets_with_manual_tags:
        prepared.count { |record| record.fetch(:tags).any? },
      total_manual_tags:
        prepared.sum { |record| record.fetch(:tags).length },
      assets_with_explanation:
        prepared.count { |record| record[:explanation] },
      assets_with_source_url:
        prepared.count { |record| record[:source_url] },
      languages: language_counts
    },

    assets: manifest_assets
  }

  File.write(
    File.join(temporary_path, "manifest.json"),
    JSON.pretty_generate(manifest) + "\n"
  )

  FileUtils.rm_rf(output_path) if File.exist?(output_path)
  FileUtils.mv(temporary_path, output_path)

  puts
  puts "Pieces export complete"
  puts "----------------------"
  puts "Assets:          #{assets.length}"
  puts "Markdown files:  #{markdown_count}"
  puts "Manual tags:     #{manifest.dig(:output, :total_manual_tags)}"
  puts "Explanations:    #{manifest.dig(:output, :assets_with_explanation)}"
  puts "Source URLs:     #{manifest.dig(:output, :assets_with_source_url)}"
  puts "Raw SHA-256:     #{raw_sha256}"
  puts "Output:           #{output_path}"
  puts
  puts "Languages:"

  language_counts.each do |language, count|
    puts format("  %-16s %d", language, count)
  end
rescue
  FileUtils.rm_rf(temporary_path)
  raise
end
```

## Final Thoughts

I don't really have a problem with Pieces moving functionality behind a paid plan. Software costs money to build and services cost money to run.

It just changed the equation for me.

I primarily wanted a convenient place to save code snippets, and at this point I would rather own those snippets as Markdown than continue storing them in another application-specific system. I had to make a few changes after running the migration script, but that's fine.

This is also a good reminder of something I keep relearning with personal tooling: **the easier it is to get your data out of a tool, the more comfortable I am putting data into it.**

Pieces gave me enough local access to recover everything I cared about, and now my snippets are sitting alongside the rest of my notes in Obsidian.

With the migration verified, I can finally uninstall Pieces without wondering what I left behind.
