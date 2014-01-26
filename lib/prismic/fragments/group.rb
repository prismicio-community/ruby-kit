module Prismic
	module Fragments

		# A fragment of type Group, which contains an array of FragmentList (which itself is a Hash of fragments).
		#
		# For instance, imagining this group is defined with two possible fragments :
		# an image fragment "image", and a text fragment "caption";
		# then accessing the first image will look like this: group[0]['image'].
		class Group < Fragment
			
			# The array of the fragment lists
			attr_accessor :fragment_list_array

			def initialize(fragment_list_array)
				@fragment_list_array = fragment_list_array
			end

			# Accessing the i-th item (fragment list) of the group: group[i]
			def [](i)
				@fragment_list_array[i]
			end

			def as_html(link_resolver = nil)
				@fragment_list_array.map { |fl| fl.as_html(link_resolver) }.join("\n")
			end

			def as_text
				@fragment_list_array.map { |fl| fl.as_text }.join("\n")
			end

			# Functions to manipulate the array

			# Loops within the array
			def each(&blk)
				@fragment_list_array.each { |elem| yield(elem) }
			end

			# Maps the array
			def map(&blk)
				@fragment_list_array.map { |elem| yield(elem) }
			end

			# Returns the length of the array
			def length
				@fragment_list_array.length
			end

			# Checks if the array is empty
			def empty?
				@fragment_list_array.empty?
			end

			class FragmentMapping

				# a hash containing all the fragments in the fragment list
				attr_accessor :fragments

				def initialize(fragments)
					@fragments = fragments
				end

				# Accessing the right fragment of the fragment list: fl['caption']
				def [](name)
					@fragments[name]
				end

				def as_html(link_resolver = nil)
					@fragments.map { |name, fragment|
						%(<section data-field="#{name}">#{fragment.as_html(link_resolver)}</section>)
					}.join("\n")
				end

				def as_text
					@fragments.values.map { |fragment| fragment.as_text }.join("\n")
				end
			end
		end
	end
end
