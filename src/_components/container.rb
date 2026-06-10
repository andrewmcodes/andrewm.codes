# Legacy responsive container layout.
#
# Prefer {PageShell} for top-level page layouts; this remains available for
# older content or nested constrained regions.
class Container < Base
  def call
    inner_html = capture do
      render(Container::Inner.new) { content }
    end
    render(Container::Outer.new(**opts)) { inner_html }
  end
end

# Inner width and padding layer for {Container}.
class Container::Inner < Box
  def call
    inner = content.to_s
    html -> {
      <<~HTML
        <div class="block relative px-4 sm:px-8 lg:px-0">
          <div class="mx-auto max-w-2xl lg:max-w-5xl">#{inner}</div>
        </div>
      HTML
    }
  end
end

# Outer centering layer for {Container}.
class Container::Outer < Box
  def call
    inner = content.to_s
    wrapped = "<div class=\"mx-auto max-w-7xl\">#{inner}</div>"
    render(Box.new(**helper_opts)) { wrapped.html_safe }
  end

  private

  def classes
    %w[block sm:px-8]
  end
end
