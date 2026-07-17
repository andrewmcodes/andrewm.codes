# Progressive-enhancement share button for post-like resources.
#
# The button starts hidden and is revealed by `frontend/javascript/share.js`
# when the browser supports the Web Share API.
class ShareButton < Base
  COMPONENT_OPTIONS = %i[resource].freeze

  private

  def resource
    opts[:resource]
  end

  def share_url
    resource.absolute_url
  end

  def share_title
    resource.data.title
  end
end
