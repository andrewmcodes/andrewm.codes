# frozen_string_literal: true

module BridgetownSvgInliner
  class Builder < Bridgetown::Builder
    def build
      liquid_tag "svg" do |attributes, tag|
        attributes = Liquid::Template.parse(attributes).render(tag.context)
        attributes = LiquidAttributes.new(attributes)

        render attributes.path, attributes.args
      end

      helper "svg" do |path, attributes|
        render path, attributes
      end
    end

    private

    def render(path, html_attributes)
      file = File.read(site.in_source_dir(path))
      xml = Nokogiri::XML(file)
      html_attributes&.each { |key, value| xml.root.set_attribute(key, value) }
      xml.root.to_xml.html_safe
    end
  end
end
