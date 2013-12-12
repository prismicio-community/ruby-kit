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
				""
			end
			# Generic as_text method for fragments, meant to be overriden by
			# specific fragment classes.
			#
			# @return [String] an empty string
			def as_text()
				""
			end
    	end
	end
end
