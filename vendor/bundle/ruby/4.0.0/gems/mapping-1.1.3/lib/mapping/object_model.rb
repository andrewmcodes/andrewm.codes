# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2016-2025, by Samuel Williams.

require_relative "model"
require_relative "descendants"

module Mapping
	# Provides a useful starting point for object based mappings. Handles, true, false, nil, Array and Hash by default, simply by passing through.
	class ObjectModel < Model
		map_identity(NilClass, TrueClass, FalseClass, String, *Mapping.lookup_descendants(Numeric))
		
		map(Array) do |items|
			items.collect{|object| map(object)}
		end
		
		map(Hash) do |hash|
			hash.inject(Hash.new) { |output, (key, value)| output[key] = map(value); output  }
		end
	end
end
