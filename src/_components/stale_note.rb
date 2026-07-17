# Alert shown on posts that have not been updated recently.
class StaleNote < Base
  COMPONENT_OPTIONS = %i[updated_at].freeze

  private

  def updated_at
    opts[:updated_at]
  end
end
