class ListTile < BaseComponent
  def initialize(url: "/", title: nil, description: nil, image: nil, clamp: "line-clamp-2")
    @url = url
    @title = title
    @description = description
    @image = image
    @clamp = clamp
  end

  attr_reader :url, :title, :description, :image, :clamp
end
