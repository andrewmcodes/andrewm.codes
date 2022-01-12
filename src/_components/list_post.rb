class ListPost < BaseComponent
  def initialize(url: "/", title: nil, description: nil, spacing: "py-4")
    @url = url
    @title = title
    @description = description
    @spacing = spacing
  end

  attr_reader :url, :title, :description, :spacing
end
