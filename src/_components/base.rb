class Base < ViewComponent::Base
  Bridgetown::ViewComponentHelpers.allow_rails_helpers :tag
  include Bridgetown::ViewComponentHelpers

  # Attribute keys that are always removed.
  INVALID_ATTRIBUTES = [:as, :classes, :class_name].freeze
  COMPONENT_OPTIONS = []

  def initialize(**opts)
    @opts = opts
    @attribute_opts = generate_attribute_opts(**opts)
  end

  def site
    @site ||= Bridgetown::Current.site
  end

  private

  attr_reader :opts, :attribute_opts

  def generate_attribute_opts(**attrs)
    attrs.except(*[INVALID_ATTRIBUTES, self.class::COMPONENT_OPTIONS].compact.flatten)
  end

  #
  # Merge the component's classes with attribute options and remove empty keys
  #
  # @return [Hash] A hash of HTML attribute names and values.
  #
  def helper_opts
    attribute_opts.merge(**tag_opts).merge(class: join_classes(classes, opts[:class_name], opts[:class])).reject { |_, v| v.nil? || v == "" }
  end

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
  # Classes that are added to the tag
  # This is overridden by the component if it has classes.
  #
  # @return [Array] Array of class names
  #
  def classes
    []
  end

  #
  # The default children for a component, supplied to the tag.
  # This is overridden by the component if it has children.
  #
  # @return [String] The default children
  #
  def children
    content
  end

  # HELPERS

  #
  # Build the class list for the tag
  #
  # @param [Array] *classes An array of strings or other arrays of classes to join
  #
  # @return [String] The class list
  #
  def join_classes(*classes)
    classes.flatten.compact.join(" ")
  end
end
