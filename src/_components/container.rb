class Container < BoxComponent
  private

  def classes
    [opts.fetch(:spacing, DEFAULT_PX), DEFAULT_PROSE_CONTAINER]
  end

  def remove_options
    [:spacing]
  end
end
