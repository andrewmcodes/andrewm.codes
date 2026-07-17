# Previous/next post navigation for post-like resources.
class PostFooterNav < Base
  COMPONENT_OPTIONS = %i[previous_resource next_resource].freeze

  private

  def previous_resource
    opts[:previous_resource]
  end

  def next_resource
    opts[:next_resource]
  end
end
