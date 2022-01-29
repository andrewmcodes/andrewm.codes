class Divider < BoxComponent
  COLORFUL_CLASSES = "border-t-0 my-8 flex h-1 w-100 bg-gradient-to-r from-sky-500 via-purple-500 to-pink-500 sm:mx-0 sm:w-full".freeze
  DEFAULT_BORDER = "border-t-1 border-zinc-300 dark:border-zinc-700".freeze
  DEFAULT_SPACING = "my-6".freeze

  private

  def classes
    class_list = opts[:classes]&.split(" ") || []
    class_list << opts.fetch(:border, DEFAULT_BORDER)
    class_list << opts.fetch(:spacing, DEFAULT_SPACING)

    cleanup_keys :spacing, :border

    if variant == :colorful
      COLORFUL_CLASSES
    else
      class_list.join(" ")
    end
  end

  def as
    :hr
  end

  def variant
    @variant ||= opts.fetch(:variant, :default)
  end
end
