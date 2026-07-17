# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2016-2025, by Samuel Williams.

module Mapping
	class Model
		PREFIX = "map_".freeze
		
		# This function generates mapping names like `map_Array` and `map_Hash` which while a bit non-standard are perfectly fine for our purposes and this never really needs to leak.
		def self.method_for_mapping(klass)
			PREFIX + klass.name.gsub(/::/, "_")
		end
		
		# Get the name of the method for mapping the given object.
		def method_for_mapping(object)
			self.class.method_for_mapping(object.class)
		end
		
		# Add a mapping from a given input class to a specific block.
		def self.map(*klasses, &block)
			klasses.each do |klass|
				method_name = self.method_for_mapping(klass)
				define_method(method_name, &block)
			end
		end
		
		# Sometimes you just want to map things to themselves (the identity function). This makes it convenient to specify a lot of identity mappings.
		def self.map_identity(*klasses)
			self.map(*klasses) {|value| value}
		end
		
		# Remove a mapping, usually an inherited one, which you don't want.
		def self.unmap(*klasses)
			klasses.each do |klass|
				method_name = self.method_for_mapping(klass)
				undef_method(method_name)
			end
		end
		
		# The primary function, which maps an input object to an output object.
		def map(root, *arguments, **options)
			method_name = self.method_for_mapping(root)
			
			self.send(method_name, root, *arguments, **options)
		end
	end
end
