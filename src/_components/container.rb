class Container < Base
  def call
    render Container::Outer.new(**opts) do
      render Container::Inner.new.with_content(content)
    end
  end
end
