class Figure < Base
  COMPONENT_OPTIONS = [:text]

  renders_one :caption
  renders_one :image, ->(**image_opts) do
    Image.new(variant: :figure, **image_opts)
  end

  private

  def text
    opts[:text] || "Figure description"
  end
end
