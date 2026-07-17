# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2025, by Samuel Williams.

module Mapping
	def self.lookup_descendants(klass)
		ObjectSpace.each_object(Class).select{|other| other < klass}
	end
end
