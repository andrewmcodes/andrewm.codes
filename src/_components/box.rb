# Primitive element renderer for atom and layout components.
#
# `Box` centralizes tag selection, attribute merging, and class composition so
# simple components can focus on their tokenized class lists.
class Box < Base
  DEFAULT_TAG = :div

  def call
    attrs = html_attributes(**helper_opts, prefix_space: true)
    inner = children.to_s
    html -> { "<#{tag_name}#{attrs}>#{inner}</#{tag_name}>" }
  end

  private

  def tag_name
    opts.fetch(:as, self.class::DEFAULT_TAG).to_sym
  end
end
