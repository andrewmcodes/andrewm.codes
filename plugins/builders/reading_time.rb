class Builders::ReadingTime < SiteBuilder
  WPM = 220

  def build
    define_resource_method :word_count do
      content.to_s.gsub(/<[^>]+>/, "").split.size
    end

    define_resource_method :reading_time do
      [(word_count / WPM.to_f).ceil, 1].max
    end
  end
end
