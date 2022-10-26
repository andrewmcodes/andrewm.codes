class Container::Inner < Box
  def call
    render Box.new(class_name: "block relative px-4 sm:px-8 lg:px-12") do
      render Box.new(class_name: "mx-auto max-w-2xl lg:max-w-5xl").with_content(content)
    end
  end
end
