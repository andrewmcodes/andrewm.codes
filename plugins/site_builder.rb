class SiteBuilder < Bridgetown::Builder
  private

  #
  # Stop production builds on errors and warn in development.
  #
  # @param [String] message The message to display in the output.
  #
  def error(message)
    Bridgetown.env.production? ? logger.error(message) && exit(1) : logger.warn(message)
  end

  #
  # Returns logger object
  #
  # @return [Bridgetown::LogAdapter]
  #
  def logger
    @logger ||= Bridgetown.logger
  end
end
