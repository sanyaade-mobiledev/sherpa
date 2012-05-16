
require 'helper'

class ParserTest < Sherpa::Test

  def setup
    @parser = Sherpa::Parser.new
    @definition = @parser.parse({file:"./test/fixtures/sass/base/headings.sass", template:"section.mustache"})
  end

  test "Parses a file and contains the filepath" do
    filepath = @definition.filepath
    assert_equal filepath, "./test/fixtures/sass/base/headings.sass"
  end

  test "Parses a file and contains the filepath" do
    title = @definition.title
    assert_equal title, "Headings"
  end

  test "Creates a subnav array for multiple sherpa blocks" do
    subnav = @definition.subnav
    assert_equal subnav, ["h3.alt"]
  end

  test "Parses a file with sherpa blocks and contains sherpa objects" do
    blocks = @definition.blocks
    assert_equal blocks.size, 2
    assert_includes blocks[0]['summary'], "## Headings"
    assert_includes blocks[0].title, "Headings"
    assert_includes blocks[0].sections[:usage_showcase], "<h1"
    assert_includes blocks[1].title, "h3.alt"
  end


  test "Handles a markdown file of handing it's contents to the raw tag" do
    definition = @parser.parse({file:"./test/fixtures/markdown/markdown.md", template:"raw.mustache"})
    assert_includes definition.raw, "Markdown Test File"
    assert_equal definition.title, "Markdown"
    assert_equal definition.filepath, "./test/fixtures/markdown/markdown.md"
    assert_empty definition.subnav
    assert_empty definition.blocks
  end

end

