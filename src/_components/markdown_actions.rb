# "Copy page / View as Markdown" control for post-like resources, modeled on
# the affordance in code.claude.com's docs. A primary "Copy page" button
# (wired up by frontend/javascript/copy_page.js) plus a dropdown of links: the
# raw .md twin and deep links that open the page in Claude or ChatGPT. The
# links work without JavaScript; only the clipboard copy needs it.
class MarkdownActions < Bridgetown::Component
  # Prompt seeded into the Claude/ChatGPT deep links; %s is the .md URL.
  PROMPT = "Read %s and help me understand it. I may have follow-up questions."

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

  private

  # Absolute .md URL so the assistant can fetch it.
  def markdown_absolute_url
    "#{@resource.absolute_url.chomp("/")}.md"
  end

  def prompt_query
    ERB::Util.url_encode(format(PROMPT, markdown_absolute_url))
  end
end
