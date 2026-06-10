# Alert shown on posts that have not been updated recently.
class StaleNote < Bridgetown::Component
  # @param updated_at [Time] resource updated timestamp
  def initialize(updated_at:)
    @updated_at = updated_at
  end

  def datetime
    @updated_at.iso8601
  end

  def label
    @updated_at.strftime("%b %Y")
  end
end
