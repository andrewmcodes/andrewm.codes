# Layout component for the primary document region.
#
# Owns the Pagefind body metadata so layouts do not repeat raw `main` markup.
#
# @option opts [String] :kind optional Pagefind metadata value for the resource kind
class MainContent < Box
  DEFAULT_TAG = :main
  COMPONENT_OPTIONS = %i[kind].freeze

  private

  def classes
    "flex-1"
  end

  def tag_opts
    attrs = {id: "main", "data-pagefind-body": true}
    attrs[:"data-pagefind-meta"] = "kind:#{opts[:kind]}" if opts[:kind]
    attrs
  end
end
