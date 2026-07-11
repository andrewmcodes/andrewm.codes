# Grid layout primitive for the repeated "list row" shape (date/meta column +
# content column + trailing action) used across post/episode/talk rows.
#
# The audit found this shape hand-rolled with inconsistent column widths
# (96px in some rows, 120px in others); `:list_row` standardizes on 96px.
#
# @option opts [Symbol] :template (`:list_row`) one of `TEMPLATES`
# @option opts [Symbol] :gap (`:none`) one of `GAPS` (same scale as {Stack})
class Columns < Box
  COMPONENT_OPTIONS = %i[template gap].freeze

  TEMPLATES = {
    list_row: "grid grid-cols-[96px_1fr_auto] max-md:grid-cols-1",
    media_row: "grid grid-cols-[64px_1fr_auto]"
  }.freeze

  private

  def classes
    cx(
      TEMPLATES.fetch(opts.fetch(:template, :list_row), TEMPLATES[:list_row]),
      GAPS.fetch(opts.fetch(:gap, :none), GAPS[:none])
    )
  end
end
