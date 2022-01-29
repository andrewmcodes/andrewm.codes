class Divider < BoxComponent
  COLORFUL_CLASSES = "border-t-0 -mx-8 my-6 flex h-1 w-[calc(100%+4rem)] bg-gradient-to-r from-yellow-400 via-red-500 to-pink-500 sm:mx-0 sm:w-full".freeze
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
