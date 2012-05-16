
require 'helper'

class DefinitionTest < Sherpa::Test
  test "attributes" do
    definition = Sherpa::Definition.new
    assert definition.respond_to?(:raw)
    assert definition.respond_to?(:markup)
    assert definition.respond_to?(:title)
    assert definition.respond_to?(:template)
    assert definition.respond_to?(:subnav)
    assert definition.respond_to?(:filepath)
    assert definition.respond_to?(:base_dir)
    assert definition.respond_to?(:blocks)
  end

  test "blocks is an array" do
    definition = Sherpa::Definition.new
    assert definition.blocks.is_a?(Array)
  end

  test "to_hash" do
    definition = Sherpa::Definition.new
    definition.raw      = 'raw'
    definition.markup   = 'markup'
    definition.title    = 'title'
    definition.template = 'template'
    definition.filepath = 'filepath'
    definition.base_dir = 'basedir'
    definition.subnav   << 'subnav'
    definition.blocks << Sherpa::Block.new(title: 'block title', sections: {'usage' => 'block usage'})
    hash = definition.to_hash

    assert_equal 'raw',         hash[:raw]
    assert_equal 'title',       hash[:title]
    assert_equal 'template',    hash[:template]
    assert_equal 'filepath',    hash[:filepath]
    assert_equal 'basedir',     hash[:base_dir]
    assert_equal 'subnav',      hash[:subnav][0]
    assert_equal 'block title', hash[:blocks][0]['title']
  end
end
