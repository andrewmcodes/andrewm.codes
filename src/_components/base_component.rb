class BaseComponent < ViewComponent::Base
  Bridgetown::ViewComponentHelpers.allow_rails_helpers :tag
  include Bridgetown::ViewComponentHelpers

  private

  def delete_keys(*keys)
    opts.delete_if { |k, v| keys.include? k }
  end
end
