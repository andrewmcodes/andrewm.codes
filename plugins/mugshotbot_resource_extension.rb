module MugshotbotResourceExtension
  module RubyResource
    def image(mode: "light", color: "007aff", pattern: "diagonal_lines", url: absolute_url)
      "https://mugshotbot.com/m?mode=#{mode}&color=#{color}&pattern=#{pattern}&hide_watermark=true&url=#{url}"
    end
  end
end

Bridgetown::Resource.register_extension MugshotbotResourceExtension
