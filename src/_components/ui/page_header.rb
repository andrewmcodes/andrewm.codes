module Ui
  # Top-level page header with canonical H1 and optional description.
  #
  # Pass a block for rich description markup. Prefer the block form over
  # `description_html` so HTML is authored in templates instead of strings.
  class PageHeader < Bridgetown::Component
    attr_reader :title,
      :description,
      :description_html,
      :description_link_label,
      :description_link_href

    # @param title [String] visible page title
    # @param description [String, nil] plain supporting copy
    # @param description_html [String, nil] trusted HTML supporting copy
    # @param description_link_label [String, nil] optional trailing inline link label
    # @param description_link_href [String, nil] optional trailing inline link URL
    def initialize(title:, description: nil, description_html: nil, description_link_label: nil, description_link_href: nil)
      @title = title
      @description = description
      @description_html = description_html
      @description_link_label = description_link_label
      @description_link_href = description_link_href
    end

    def description_link?
      description_link_label && description_link_href
    end

    def rich_description
      @rich_description ||= content.to_s
    end

    def rich_description?
      rich_description.strip != ""
    end
  end
end
