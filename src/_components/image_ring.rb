class ImageRing < Box
  DEFAULT_TAG = :div

  private

  def classes
    %w[relative
      mt-1
      flex
      h-10
      w-10
      flex-none
      items-center
      justify-center
      rounded-full
      shadow-md
      shadow-radix-slate9/3
      ring-radix-slate7
      dark:border
      dark:border-radix-slate6
      dark:bg-radix-slate3
      ring-1
      dark:ring-0]
  end
end
