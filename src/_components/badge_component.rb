class BadgeComponent < ApplicationComponent
  required :title
  option :tone, default: "neutral"
  option :weight, default: "medium"

  def render_in(view_context)
    <<~HTML
      <badge class="no-sr block inline-flex items-center px-3 py-0.5 rounded-full text-sm font-semibold #{tone_class}">
        ##{title}
      </badge>
    HTML
  end

  private

  TONES = { info: "blue", promote: "green", neutral: "gray" }

  def tone_class
    "border border-#{TONES.fetch(tone.to_sym, "gray")}-500 text-#{TONES.fetch(tone.to_sym, "gray")}-500"
  end
end
