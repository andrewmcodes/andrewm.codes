# Command palette shell and search UI.
#
# Purely static markup — all behavior lives in frontend/javascript/cmdk.js,
# which reads `#cmdk`, `#cmdk-input`, `#cmdk-results`, and
# `[data-cmdk-item]`/`data-idx` on rendered result rows. Do not rename any of
# those hooks.
class Cmdk < Base
  KBD = "font-mono text-[11px] bg-sage-3 border border-sage-5 rounded text-sage-11 px-1.5 py-px"

  HINTS = [
    {keys: "↑↓", label: "navigate"},
    {keys: "↵", label: "open"},
    {keys: "esc", label: "close"}
  ].freeze

  def kbd_class
    KBD
  end

  def hints
    HINTS
  end
end
