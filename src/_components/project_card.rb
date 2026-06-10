# Project card for local project resources and GitHub API repository hashes.
class ProjectCard < Bridgetown::Component
  # @param project [Bridgetown::Resource::Base, Hash] project resource or repo hash
  def initialize(project:)
    @project = project
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

  private

  def resource?
    @project.respond_to?(:data)
  end

  def repo_url
    return nil unless resource?
    @project.data.repo || @project.data.url
  end
end
