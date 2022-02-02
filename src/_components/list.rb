class List < BoxComponent
  private

  def classes
    [
      opts.fetch(:divide, "divide-y divide-zinc-300 dark:divide-zinc-700"),
      "not-prose list-none pl-0",
      DEFAULT_FLEX_COL,
      DEFAULT_SPACE_Y
    ]
  end

  def add_options
    opts[:role] ||= "list"
  end

  def remove_options
    [:divide]
  end

  def default_tag
    :ul
  end
end
