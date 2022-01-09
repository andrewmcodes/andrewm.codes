class ListComponent < BaseComponent
  renders_many :items, "ListItem"
  renders_many :posts, "ListPost"
  renders_many :tiles, "ListTile"

  def initialize(classes: "list-none not-prose pl-0", role: "list", divide: true)
    @list_classes = classes
    @role = role
    @divide = divide
  end

  def divide_classes
    @divide ? "divide-y divide-skin-base space-y-2" : ""
  end
end
