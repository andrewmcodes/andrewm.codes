# Color-theme control: a System / Light / Dark segmented radiogroup.
#
# The inline script in default.erb applies the theme before paint;
# frontend/javascript/theme.js persists the choice, manages roving tabindex /
# arrow-key selection, and keeps the active segment in sync across Turbo
# navigations. `[data-theme-toggle]` / `[data-theme-value]` / `aria-checked`
# are read there — do not rename.
#
# @param context [String, nil] disambiguates the radiogroup's accessible name
#   when more than one instance is on the page (footer + mobile menu).
class ThemeToggle < Base
  SEGMENT_BUTTON = "size-9 rounded-full inline-flex items-center justify-center text-sage-10 cursor-pointer hover:text-sage-12 transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-mint-8 aria-checked:bg-sage-5 aria-checked:text-sage-12"

  # Order drives both the radiogroup's tab order and its initial checked
  # segment ("system" is the default until frontend/javascript/theme.js syncs
  # it to the stored/OS preference on load).
  SEGMENTS = [
    {value: "system", label: "System", aria_label: "Sync theme with system", checked: true},
    {value: "light", label: "Light", aria_label: "Use light theme", checked: false},
    {value: "dark", label: "Dark", aria_label: "Use dark theme", checked: false}
  ].freeze

  def initialize(context: nil)
    @context = context
  end

  def group_label
    @context ? "Color theme (#{@context})" : "Color theme"
  end

  def segments
    SEGMENTS
  end

  def segment_button_class
    SEGMENT_BUTTON
  end
end
