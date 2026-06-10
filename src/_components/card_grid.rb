# Grid wrapper for repeated card-style content.
#
# Use for project cards and other repeated card components that should share
# the global `.card-grid` behavior.
class CardGrid < Box
  private

  def classes
    cx("card-grid")
  end
end
