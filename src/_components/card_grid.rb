# The grid, for peers with no meaningful order.
#
# Two columns down to 680px, then one. Cells are separated by the gap and
# nothing else — no rule between them and no border around them, because this
# world separates by space. What makes a tile read as a tile here is that it is
# a plate with its own padding, not that it is boxed.
class CardGrid < Box
  private

  def classes
    cx("card-grid")
  end
end
