class SiteBuilder < Bridgetown::Builder
  private

  def error(message)
    logger.error(message)
    raise message if Bridgetown.env.development?
  end

  def warn(message)
    logger.warn("WARNING: #{message}")
  end

  def logger
    @logger ||= Bridgetown.logger
  end
end
