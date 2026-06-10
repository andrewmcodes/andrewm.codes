class Builders::ContentFreshness < SiteBuilder
  STALE_AFTER_SECONDS = 2 * 365 * 24 * 60 * 60

  def build
    define_resource_method :updated_at do
      raw = data.last_modified_at || data.updated || date
      coerce_time(raw)
    end

    # Opt out per-post with `stale_alert: false` (matches the `toc: false`
    # convention) or `evergreen: true` for posts whose content doesn't age.
    # CFPs are archival, event-tied proposals — a freshness note never applies.
    define_resource_method :stale? do
      return false if data.kind == "cfp"
      return false if data.stale_alert == false
      return false if data.evergreen == true
      updated = updated_at
      updated && updated < (Time.now - STALE_AFTER_SECONDS)
    end

    define_resource_method :coerce_time do |value|
      return nil if value.nil?
      return value.to_time if value.respond_to?(:to_time)
      Time.parse(value.to_s)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
