# Progressive-enhancement share button for post-like resources.
#
# The button starts hidden and is revealed by `frontend/javascript/share.js`
# when the browser supports the Web Share API.
class ShareButton < Bridgetown::Component
  # @param resource [Bridgetown::Resource::Base] resource being shared
  # @param class_name [String, nil] placement classes from the caller; the
  #   button ships hidden, so a margin has to ride on the button itself rather
  #   than on a wrapper that would hold the space open without the API.
  def initialize(resource:, class_name: nil)
    @resource = resource
    @class_name = class_name
  end

  def button_classes
    ["share-btn", @class_name].compact.join(" ")
  end

  def share_url
    @resource.absolute_url
  end

  def share_title
    @resource.data.title
  end
end
