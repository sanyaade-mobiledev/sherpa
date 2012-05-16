
require 'helper'

class BlockTest < Sherpa::Test
  test "attributes" do
    block = Sherpa::Block.new
    assert block.respond_to?(:title)
    assert block.respond_to?(:sections)
  end

  test "sections is a hash" do
    block = Sherpa::Block.new
    assert block.sections.is_a?(Hash)
  end

  test "can set a section via a hash like api" do
    block = Sherpa::Block.new
    block[:something] = 'something'
    assert_equal block[:something], 'something'
  end

  test "Cleans up the showcase blocks for newline content" do
    block = Sherpa::Block.new title: "\ntitle"
    block[:usage_showcase] = "\n<div></div>\n"
    assert_equal block[:usage_showcase], "<div></div>\n"
    assert_equal block.title, "\ntitle"
  end
end
