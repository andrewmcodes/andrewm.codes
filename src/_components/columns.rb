class Columns < BoxComponent
  private

  def classes
    [opts.fetch(:spacing, DEFAULT_SPACE_Y), DEFAULT_FLEX_COL]
  end

  def remove_options
    [:spacing]
  end
end
