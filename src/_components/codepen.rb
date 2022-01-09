class Codepen < BoxComponent
  def post_initialize(**opts)
    @w = opts.fetch :width, "100%"
    @h = opts.fetch :height, "300px"
    @lazy = opts.fetch :lazy, false
    @tab = opts.fetch :tab, "result"
    @theme = opts.fetch :theme, "dark"
    @pen_id = opts.fetch :pen_id, "yLbdJgj"

    cleanup_keys :width, :height, :lazy, :tab, :theme, :pen_id
  end

  def call
    tag.iframe(
      class: classes,
      height: h,
      style: "width:#{w};",
      scrolling: "no",
      title: "CodePen Embed",
      src: codepen_url,
      frameborder: 0,
      loading: lazy ? "lazy" : "eager",
      allowtransparency: true,
      allowfullscreen: true
    ) do
      Link.new(href: codepen_url, external: true).with_content("See the Pen")
    end
  end

  private

  attr_reader :opts, :w, :h, :lazy, :tab, :theme, :pen_id

  def classes
    ""
  end

  def codepen_url
    "https://codepen.io/andrewmcodes/embed/#{pen_id}?default-tab=#{tab}"
  end
end
