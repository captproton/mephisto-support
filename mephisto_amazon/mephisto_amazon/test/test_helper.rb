# This file is a basic copy of the helper in Liquid's tests

#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../no_mephisto_init'

require File.dirname(__FILE__) + '/../lib/mephisto_amazon'
require File.dirname(__FILE__) + '/../lib/mephistoamazon/keyword_search'
require File.dirname(__FILE__) + '/../lib/mephistoamazon/asin_search'
require File.dirname(__FILE__) + '/../lib/mephistoamazon/search_delegate'
require File.dirname(__FILE__) + '/../lib/mephistoamazon/response_drop'

require 'flexmock'
require 'test/unit'
require 'test/unit/testresult'
require 'test/unit/assertions'
require 'liquid'
require 'breakpoint'

require File.dirname(__FILE__) + '/' + 'keyword_search_test'
require File.dirname(__FILE__) + '/' + 'search_delegate_test'
require File.dirname(__FILE__) + '/' + 'asin_search_test'

Breakpoint.activate_drb

module Test
  module Unit
    module Assertions
      def assert_template_result(expected, template, assigns={}, message=nil)
        assert_equal expected, Liquid::Template.parse(template).render(assigns)
      end 
    end  
  end
end