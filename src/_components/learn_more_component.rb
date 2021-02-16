class LearnMoreComponent < ApplicationComponent
  required :href

  def render_in(view_context)
    <<~HTML
      <a class="inline-block" href="#{href}">
        <span class="sr-only">Learn More</span>
        <svg
          class="inline"
          xmlns="http://www.w3.org/2000/svg"
          width="0.75em"
          height="0.75em"
          viewBox="0 0 24 24"
          fill="none"
          stroke="#999"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <circle cx="12" cy="12" r="10"></circle>
          <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
          <line x1="12" y1="17" x2="12" y2="17"></line>
        </svg>
      </a>
    HTML
  end
end
