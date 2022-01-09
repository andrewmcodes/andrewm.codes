class ListPost < BaseComponent
  def initialize(url: "/", title: nil, description: nil)
    @url = url
    @title = title
    @description = description
  end

  attr_reader :url, :title, :description
end
