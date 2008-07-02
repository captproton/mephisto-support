
require File.dirname(__FILE__) + '/test_helper'

require 'test/unit/testsuite'
require 'test/unit/ui/reporter'
require 'stringio'
require 'test/unit/ui/console/testrunner'
require 'fileutils'

suite = Test::Unit::TestSuite.new("Mephisto Amazon test suite")

suite << KeywordSearchTest.suite
suite << SearchDelegateTest.suite

FileUtils.mkdir_p 'build/report'
Test::Unit::UI::Reporter.run(suite, '../build/report', :xml)
Test::Unit::UI::Reporter.run(suite, '../build/report')