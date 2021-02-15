class ApplicationComponent < OptStruct.new
  include Bridgetown::Filters::URLFilters
  include Bridgetown::Filters::DateFilters
end
