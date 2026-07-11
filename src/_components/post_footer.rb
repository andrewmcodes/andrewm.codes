# Footer composition for post-like layouts.
#
# Combines previous/next navigation, the progressive share button, and optional
# Bluesky comments so the post layout does not own footer structure.
class PostFooter < Base
  COMPONENT_OPTIONS = %i[resource previous_resource next_resource].freeze

  private

  def resource
    opts[:resource]
  end

  def previous_resource
    opts[:previous_resource]
  end

  def next_resource
    opts[:next_resource]
  end
end
