class PageBannerComponent < ApplicationComponent
  option :title, default: "TODO"
  option :description, default: false
  option :subtitle, default: false

  def render_in(view_context)
    <<~HTML
      <div class="flex flex-col space-y-2 md:items-center md:text-center">
        <h1 class="text-4xl lg:text-6xl">#{title}</h1>
        #{description_markup}
        #{subtitle_markup}
      </div>
    HTML
  end

  def description_markup
    return unless description

    "<p class=\"text-2xl\">#{description}</p>"
  end

  def subtitle_markup
    return unless subtitle

    "<p class=\"text-2xl\">#{subtitle}</p>"
  end
end
