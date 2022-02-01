class Divider < BoxComponent
  DIVIDER_COLORFUL_CLASSES = "border-t-0 flex h-1 w-100 bg-gradient-to-r from-sky-500 via-purple-500 to-pink-500 sm:mx-0 sm:w-full".freeze
  DEFAULT_DIVIDER_CLASSES = "border-t-1 border-zinc-300 dark:border-zinc-700".freeze
  DEFAULT_DIVIDER_MY = "my-6".freeze

  private

  def classes
    [
      variant == :colorful ? DIVIDER_COLORFUL_CLASSES : DEFAULT_DIVIDER_CLASSES,
      opts.fetch(:spacing, DEFAULT_DIVIDER_MY)
    ]
  end

  def remove_options
    [:spacing, :border]
  end

  def default_tag
    :hr
  end
end
