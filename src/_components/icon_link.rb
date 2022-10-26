class IconLink < Box
  DEFAULT_TAG = :a

  renders_one :icon, ->(**icon_opts) do
    Icon.new(**icon_opts)
  end

  private

  def href
    opts[:href]
  end

  def title
    opts[:title]
  end
end
