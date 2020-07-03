# encoding: utf-8
module Prismic
    module Fragments
      class BooleanField < Fragment
        attr_accessor :value
  
        def initialize(value)
          @value = value
        end
  
        def as_html(link_resolver=nil)
            if (@value === true)
                %(<input type="checkbox" checked="checked" />)
            else
                %(<input type="checkbox" />)
            end
        end
      end
    end
  end
  