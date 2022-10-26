class Icon < Base
  COMPONENT_OPTIONS = [:name]

  def call
    svg "/assets/icons/#{opts[:name]}.svg", **helper_opts
  end

  private

  def tag_opts
    {
      width: opts.fetch(:width, 15),
      height: opts.fetch(:height, 15)
    }
  end
end
