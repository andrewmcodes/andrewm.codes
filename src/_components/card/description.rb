class Card::Description < Box
  DEFAULT_TAG = :p

  private

  def classes
    %w[relative z-10 mt-2 text-sm text-radix-slate11]
  end
end
