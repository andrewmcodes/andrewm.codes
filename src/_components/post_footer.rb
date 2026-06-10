# Footer composition for post-like layouts.
#
# Combines previous/next navigation, the progressive share button, and optional
# Bluesky comments so the post layout does not own footer structure.
class PostFooter < Bridgetown::Component
  # @param resource [Bridgetown::Resource::Base] current post-like resource
  # @param previous_resource [Bridgetown::Resource::Base, nil] older resource
  # @param next_resource [Bridgetown::Resource::Base, nil] newer resource
  def initialize(resource:, previous_resource:, next_resource:)
    @resource = resource
    @previous_resource = previous_resource
    @next_resource = next_resource
  end
end
