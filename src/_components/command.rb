# A single terminal command, rendered as a code block with a muted prompt.
#
# Emits `<pre><code>` so it inherits the site's code-block treatment and is
# picked up by `copy_code.js` like any fenced block — the prompt is excluded
# from selection, so copying gives the command without the `$`.
class Command < Base
end
