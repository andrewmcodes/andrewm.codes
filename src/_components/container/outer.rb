class Container::Outer < Box
  def call
    render Box.new(**helper_opts) do
      render Box.new(class_name: "mx-auto max-w-7xl lg:px-8").with_content(content)
    end
  end

  private

  def classes
    %w[block sm:px-8]
  end
end
