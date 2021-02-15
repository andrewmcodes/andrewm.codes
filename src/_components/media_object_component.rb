class MediaObjectComponent < ApplicationComponent
  required :name, :url
  option :description, default: ""
  option :image, default: ""

  def render_in(view_context)
    <<~HTML
        <a
          class="flex py-4 rounded-lg sm:p-4 sm:hover:bg-gray-100 sm:dark:hover:bg-gray-900"
          href="#{url}"
          target="_blank"
          rel="nooopener noreferrer">
        <div class="box-border relative inline-block w-16 h-16 overflow-hidden">
          <img alt="#{name} icon"
                src="#{image}"
                class="border border-gray-100 dark:border-gray-900 rounded-xl flex-0">
        </div>
        <div class="flex flex-col justify-center flex-1 col-span-3 pl-5 space-y-2">
          <div class="flex flex-col">
            <p>#{name}</p>
            <p class="text-base font-normal text-gray-600 dark:text-gray-400">
              #{description}
            </p>
          </div>
        </div>
      </a>
    HTML
  end

  private

  def image_src
    "/images/#{name.parameterize.underscore}.jpg"
  end
end
