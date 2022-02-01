class ListItem < BoxComponent
  private

  def classes
    [opts.fetch(:spacing, DEFAULT_PY)]
  end

  def remove_options
    :py
  end

  def default_tag
    :li
  end
end
