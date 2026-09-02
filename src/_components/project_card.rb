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

  # Only a status worth remarking on earns a chip. Nearly every project is
  # active, so labelling them all said nothing and spent the accent fifteen
  # times on one page; the exception is the only part that carries information.
  def exceptional_status
    s = status.to_s
    (s.empty? || s == "active") ? nil : s
  end

  # Counts read as words rather than as glyphs: the site's icon set is stroked
  # and GitHub's star and fork marks are filled, so borrowing them would put two
  # icon languages in one footer to say what two nouns already say.
  def facts
    [
      count_label(stars, "star"),
      count_label(forks, "fork")
    ].compact
  end

  def external?
    true
  end

  private

  def count_label(value, noun)
    n = value.to_i
    return nil if value.nil? || n <= 0
    "#{n} #{noun}#{"s" unless n == 1}"
  end

  def resource?
    @project.respond_to?(:data)
  end

  def repo_url
    return nil unless resource?
    @project.data.repo || @project.data.url
  end
end
