class Box < Base
  TEXT_WEIGHT = {
    default: "font-base",
    medium: "font-medium",
    semibold: "font-semibold",
    bold: "font-bold",
    extrabold: "font-extrabold",
    black: "font-black"
  }

  DEFAULT_TAG = :div

  def call
    tag.send(tag_name, children, **helper_opts)
  end

  private

  #
  # A hash of attributes that are merged with attribute_opts
  # to be added to the tag
  #
  # @return [Hash] A hash of HTML attribute names and values.
  #
  def tag_opts
    {}
  end

  #
  # The default tag name for the component, supplied to the tag.
  # Override default_tag to change the default in the component.
  #
  # @return [Symbol] The default tag name
  #
  def tag_name
    opts.fetch(:as, self.class::DEFAULT_TAG).to_sym
  end
end
