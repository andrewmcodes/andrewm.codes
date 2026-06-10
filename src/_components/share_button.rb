# Progressive-enhancement share button for post-like resources.
#
# The button starts hidden and is revealed by `frontend/javascript/share.js`
# when the browser supports the Web Share API.
class ShareButton < Bridgetown::Component
  # @param resource [Bridgetown::Resource::Base] resource being shared
  def initialize(resource:)
    @resource = resource
  end

  def share_url
    @resource.absolute_url
  end

  def share_title
    @resource.data.title
  end
end
