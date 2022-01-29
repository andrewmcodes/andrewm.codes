class DataItem < BaseComponent
  renders_one :description
  renders_one :title
  renders_one :subtitle

  def initialize(href: "/", clamp: "line-clamp-2")
    @href = href
    @clamp = clamp
  end

  attr_reader :href, :clamp
end
