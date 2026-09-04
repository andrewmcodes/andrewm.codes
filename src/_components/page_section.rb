# A major section of a view: a quiet label above the work, and nothing else.
#
# The old label rail is gone with the rules that made it legible. In a world
# separated by space rather than lines, a 168px margin carrying an uppercase
# mono tab competed with the titles it was introducing; here the label is one
# secondary-tone word directly above its list, and where the section continues
# elsewhere the whole label is the link to it.
#
# A section owns no vertical space of its own. The `Stack` that places it
# decides how far it sits from its neighbours, which is the whole reason the
# homepage's rhythm can be read off one line of `index.erb`.
class PageSection < Bridgetown::Component
  # @param label [String, nil] the section's name; nil renders content alone
  # @param description [String, nil] one line on what the section holds
  # @param link_label [String, nil] label for the "everything else" action
  # @param link_href [String, nil] destination for that action
  def initialize(label: nil, description: nil, link_label: nil, link_href: nil, spacing: nil)
    @label = label
    @description = description
    @link_label = link_label
    @link_href = link_href
  end

  attr_reader :label, :description, :link_label, :link_href

  def labelled? = !label.nil?

  # The label and the "see the rest" action are the same object. Two adjacent
  # controls saying the same thing is two chances to miss both.
  def link? = !link_href.nil?
end
