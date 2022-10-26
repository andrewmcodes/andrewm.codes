class Card::Title < Box
  DEFAULT_TAG = :h2
  COMPONENT_OPTIONS = [:href]

  def call
    if opts[:href]
      render Heading.new(variant: :title_sm) do
        render(Card::Link.new(href: opts[:href]).with_content(children))
      end
    else
      render Heading.new(variant: :title_sm, **helper_opts).with_content(children)
    end
  end
end
