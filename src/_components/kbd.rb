class Kbd < Box
  DEFAULT_TAG = :kbd

  private

  def classes
    %w[rounded px-1 leading-[.875rem] text-lg bg-radix-slate2 text-radix-gray12 border border-radix-slate6 min-w-[2em] h-6]
  end
end
