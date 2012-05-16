require 'minitest/autorun'
require 'sherpa'

module Sherpa
  class Test < MiniTest::Unit::TestCase
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end

    def default_test
    end
  end
end

