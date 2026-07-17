# Project card for local project resources and GitHub API repository hashes.
class ProjectCard < Base
  CARD_CLASSES = "group flex flex-col gap-1 bg-sage-1 hover:bg-sage-2 transition-colors py-3.5 md:p-5"
  # Neutral always — status used to switch to a decorative mint fill for
  # "active", which broke the mint-is-interactive-only rule. The status text
  # itself communicates state; the badge chrome stays sage regardless.
  STATUS_BADGE_CLASSES = "ml-auto rounded-full border border-sage-4 px-1.5 py-px"

  # @param project [Bridgetown::Resource::Base, Hash] project resource or repo hash
  def initialize(project:)
    @project = project
    super()
  end

  def name
    resource? ? @project.data.title : @project[:name]
  end

  def desc
    resource? ? @project.data.description : @project[:desc]
  end

  def status
    resource? ? (@project.data.status || "active") : @project[:status]
  end

  def lang
    resource? ? @project.data.lang : @project[:lang]
  end

  def lang_color
    resource? ? (@project.data.lang_color || "#701516") : @project[:color]
  end

  def stars
    resource? ? @project.data.stars : @project[:stars]
  end

  def forks
    resource? ? @project.data.forks : @project[:forks]
  end

  def href
    resource? ? (repo_url || "#") : @project[:href]
  end

  def external?
    true
  end

  def card_classes
    CARD_CLASSES
  end

  def status_badge_classes
    STATUS_BADGE_CLASSES
  end

  private

  def resource?
    @project.respond_to?(:data)
  end

  def repo_url
    return nil unless resource?
    @project.data.repo || @project.data.url
  end
end
