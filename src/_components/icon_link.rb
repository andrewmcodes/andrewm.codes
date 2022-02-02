class IconLink < BaseComponent
  renders_one :icon

  def initialize(href: "/", classes: "inline-flex items-center justify-center p-2 rounded-md", hover: "hover:bg-zinc-300 hover:text-zinc-800 dark:hover:bg-zinc-700 dark:hover:text-zinc-300", alt: nil, **opts)
    @href, @classes, @hover, @alt, @opts = href, classes, hover, alt, opts
  end

  attr_reader :href, :classes, :alt, :opts, :hover
end
