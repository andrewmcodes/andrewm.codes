# "Copy page / View as Markdown" control for post-like resources, modeled on
# the affordance in code.claude.com's docs. A primary "Copy page" button
# (wired up by frontend/javascript/copy_page.js) plus a dropdown of links: the
# raw .md twin and deep links that open the page in Claude or ChatGPT. The
# links work without JavaScript; only the clipboard copy needs it.
#
# `.md-actions`/`data-md-url`, `.md-copy`/`.md-copy-label`, and
# `details.md-menu` are read by copy_page.js — do not rename.
class MarkdownActions < Base
  # Prompt seeded into the Claude/ChatGPT deep links; %s is the .md URL.
  PROMPT = "Read %s and help me understand it. I may have follow-up questions."

  MENU_ITEM_CLASS = "flex items-center gap-2 px-3 py-1.5 hover:bg-sage-3 hover:text-mint-11 transition-colors"

  # @param resource [Bridgetown::Resource::Base] post-like resource
  def initialize(resource:)
    @resource = resource
  end

  # Same-origin .md path — used for the clipboard fetch and the
  # "View as Markdown" link, so it works on any host (preview or prod).
  def markdown_path
    "#{@resource.relative_url.chomp("/")}.md"
  end

  def claude_url
    "https://claude.ai/new?q=#{prompt_query}"
  end

  def chatgpt_url
    "https://chatgpt.com/?q=#{prompt_query}"
  end

  # @return [Array<Hash>] the dropdown menu rows: icon, label, href, and
  #   whether the link opens in a new tab.
  def menu_items
    [
      {href: markdown_path, icon: "link_icon", label: "View as Markdown", external: false},
      {href: claude_url, icon: "arrow_top_right", label: "Open in Claude", external: true},
      {href: chatgpt_url, icon: "arrow_top_right", label: "Open in ChatGPT", external: true}
    ]
  end

  def menu_item_class
    MENU_ITEM_CLASS
  end

  private

  # Absolute .md URL so the assistant can fetch it.
  def markdown_absolute_url
    "#{@resource.absolute_url.chomp("/")}.md"
  end

  def prompt_query
    ERB::Util.url_encode(format(PROMPT, markdown_absolute_url))
  end
end
