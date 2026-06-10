# Previous/next post navigation for post-like resources.
class PostFooterNav < Bridgetown::Component
  # @param previous_resource [Bridgetown::Resource::Base, nil] older resource
  # @param next_resource [Bridgetown::Resource::Base, nil] newer resource
  def initialize(previous_resource:, next_resource:)
    @previous_resource = previous_resource
    @next_resource = next_resource
  end
end
