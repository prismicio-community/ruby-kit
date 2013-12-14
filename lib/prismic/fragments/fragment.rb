# encoding: utf-8
module Prismic
	module Fragments
		# Generic fragment, this class is to be extended by all fragment classes.
		class Fragment
			# Generic as_html method for fragments, meant to be overriden by
			# specific fragment classes.
			#
			# @return [String] an empty string
			def as_html(link_resolver = nil)
				raise NotImplementedError, "Method #{__method__} is not implemented for #{inspect}", caller
			end
			# Generic as_text method for fragments, meant to be overriden by
			# specific fragment classes.
			#
			# @return [String] an empty string
			def as_text()
				raise NotImplementedError, "Method #{__method__} is not implemented for #{inspect}", caller
			end
    	end
	end
end
