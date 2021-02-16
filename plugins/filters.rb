module MyFilters
  def emoji(name, emoji)
    "<span role=\"img\" aria-label=\"#{name.capitalize}\">#{emoji}</span>"
  end
end

Liquid::Template.register_filter MyFilters
Bridgetown::RubyTemplateView::Helpers.include MyFilters
