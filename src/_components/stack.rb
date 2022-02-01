class Stack < BoxComponent
  private

  def classes
    [opts.fetch(:spacing, "space-y-4 md:space-y-8 lg:space-y-12"), DEFAULT_FLEX_COL]
  end

  def remove_options
    [:spacing]
  end
end
