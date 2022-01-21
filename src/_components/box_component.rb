class BoxComponent < BaseComponent
  def initialize(**opts)
    @opts = opts
    @site = Bridgetown::Current.site
    post_initialize(**opts)
  end

  def call
    call_as = as
    call_classes = classes
    cleanup_keys :classes, :as

    tag.send call_as, content, class: call_classes, **opts
  end

  def post_initialize(**opts)
    nil
  end

  attr_accessor :opts, :site

  private

  def classes
    opts.fetch(:classes, "")
  end

  def as
    opts.fetch(:as, :div)
  end
end
