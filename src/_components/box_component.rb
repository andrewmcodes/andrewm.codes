class BoxComponent < BaseComponent
  DEFAULT_TAG = :div
  DEFAULT_OPTIONS = [:classes, :as, :variant].freeze
  DEFAULT_PX = "px-4".freeze
  DEFAULT_PY = "py-4".freeze
  DEFAULT_SPACE_Y = "space-y-4".freeze
  DEFAULT_FLEX_COL = %w[flex flex-col].freeze
  DEFAULT_PROSE_CONTAINER = %w[w-full mx-auto max-w-prose].freeze

  attr_accessor :opts, :site, :class_names, :tag_name

  def initialize(**opts)
    @opts = opts
    @site = Bridgetown::Current&.site || Bridgetown::Site.new
    @tag_name = as
    @class_names = [classes, opts[:classes]].flatten.compact
  end

  def before_render
    delete_keys DEFAULT_OPTIONS
    delete_keys remove_options
    add_options
  end

  def call
    tag.send tag_name, content, class: class_names, **opts
  end

  private

  #
  # Classes added to in the component to be overridden.
  #
  # @return [Array[String]] Array of class names
  #
  def classes
    []
  end

  #
  # Add options to the opts object.
  #
  # @return void
  #
  def add_options
  end

  #
  # Options that are not valid HTML and need to be deleted.
  #
  # @return [Array[Symbol]] keys to delete
  #
  def remove_options
    []
  end

  #
  # Default tag override in the component.
  #
  # @return [Symbol] the default tag name
  #
  def default_tag
    DEFAULT_TAG
  end

  #
  # Tag name for the element, defaults to the default_tag.
  #
  # @return [Symbol] the overriden or default tag name
  #
  def as
    @as ||= opts.fetch(:as, default_tag)
  end

  #
  # Variant for the component
  #
  # @return [Symbol] the overriden or default variant
  #
  def variant
    @variant ||= opts.fetch(:variant, :default)
  end
end
