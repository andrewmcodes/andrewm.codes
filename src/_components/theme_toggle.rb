# Color-theme control: a System / Light / Dark segmented radiogroup.
#
# The inline script in default.erb applies the theme before paint;
# frontend/javascript/theme.js persists the choice, manages roving tabindex /
# arrow-key selection, and keeps the active segment in sync across Turbo
# navigations.
#
# @param context [String, nil] disambiguates the radiogroup's accessible name
#   when more than one instance is on the page (footer + mobile menu).
class ThemeToggle < Bridgetown::Component
  def initialize(context: nil)
    @context = context
  end

  def group_label
    @context ? "Color theme (#{@context})" : "Color theme"
  end
end
