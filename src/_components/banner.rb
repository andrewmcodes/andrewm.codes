class Banner < BaseComponent
  renders_one :message
  renders_one :cta

  def initialize(dismissable: true)
    @dismissable = dismissable
  end

  attr_reader :dismissable
end
