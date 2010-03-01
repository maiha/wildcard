require 'spec'
require 'rr'
Spec::Runner.configure do |config|
  config.mock_with RR::Adapters::Rspec
end

require File.join(File.dirname(__FILE__), '../lib/wildcard')

module Spec::Example::Subject::ExampleGroupMethods
  def expand(src, expected, &block)
    it "expand(#{src.inspect})" do
      Wildcard.new(src).expand.should == (expected || block.call)
    end
  end
end

describe Wildcard do
  ######################################################################
  ### api

  it "should provide .expand" do
    Wildcard.should respond_to(:expand)
  end

  describe ".expand" do
    it "should delegate to #expand" do
      mock.instance_of(Wildcard).expand
      Wildcard.expand('')
    end
  end

  it "should provide #expand" do
    Wildcard.new('').should respond_to(:expand)
  end

  ######################################################################
  ### expand

  # accept string
  expand "a",                   ["a"]

  # accept array
  expand ["a","b"],             ["a","b"]

  # range
  expand "{1..3}",              ["1","2","3"]
  expand "a{1..3}",             ["a1","a2","a3"]
  expand "a{1..3}b",            ["a1b","a2b","a3b"]
  expand "{09..11}",            ["09", "10", "11"]
  expand "a{09..11}b",          ["a09b", "a10b", "a11b"]

  # selection
  expand "{1,3,5}",             ["1","3","5"]
  expand "a{,x,y}b",            ["ab", "axb", "ayb"]
  expand "a{x,,y}b",            ["axb", "ab", "ayb"]
  expand "a{1,3,x,y,}b",        ["a1b", "a3b", "axb", "ayb", "ab"]
  expand "a{,x,,,y,,}b",        ["ab", "axb", "ayb"]

  # complexed
  expand "X{a..c}Y{0,5}Z",      ["XaY0Z", "XaY5Z", "XbY0Z", "XbY5Z", "XcY0Z", "XcY5Z"]
end
