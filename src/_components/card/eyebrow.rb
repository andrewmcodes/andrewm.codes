class Card::Eyebrow < Base
  COMPONENT_OPTIONS = [:decorate]

  private

  def classes
    c = %w[relative z-10 order-first mb-3 flex items-center text-sm text-radix-slate11]
    c << "pl-3.5" if decorate?
    c
  end

  def decorate?
    opts[:decorate] == true
  end
end
