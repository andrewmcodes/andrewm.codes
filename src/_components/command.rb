# Inline command/code atom for keyboard commands or terminal snippets.
class Command < Base
  # @return [String] classes for the leading "$" prompt chip
  def prompt_classes
    "py-1 px-2 rounded-l-md text-sage-12 bg-sage-3"
  end

  # @return [String] classes for the command text itself
  def code_classes
    cx(FONT_FAMILY[:mono], "py-1 px-2 bg-sage-3 rounded-r-md text-sage-12")
  end
end
