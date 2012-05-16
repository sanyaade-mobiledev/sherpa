
require 'helper'

class ParserTest < Sherpa::Test

  def setup
    @parser = Sherpa::Parser.new
    @file_blocks = @parser.parse({file:"./test/fixtures/sass/base/headings.sass", template:"section.mustache"})
  end

  test "Parses a file with sherpa blocks and contains the root objects associated with a file" do
    assert_includes @file_blocks, :raw
    assert_includes @file_blocks, :title
    assert_includes @file_blocks, :subnav
    assert_includes @file_blocks, :filepath
  end

  test "Parses a file and contains the filepath" do
    filepath = @file_blocks[:filepath]
    assert_equal filepath, "./test/fixtures/sass/base/headings.sass"
  end

  test "Parses a file and contains the filepath" do
    title = @file_blocks[:title]
    assert_equal title, "Headings"
  end

  test "Creates a subnav array for multiple sherpa blocks" do
    subnav = @file_blocks[:subnav]
    assert_equal subnav, ["h3.alt"]
  end

  test "Parses a file with sherpa blocks and contains sherpa objects" do
    sherpas = @file_blocks[:sherpas]
    assert_includes @file_blocks, :sherpas
    assert_equal sherpas.size, 2
    assert_includes sherpas[0]["summary"], "## Headings"
    assert_includes sherpas[0][:title], "Headings"
    assert_includes sherpas[0][:usage_showcase], "<h1"
    assert_includes sherpas[1]["summary"], "h3.alt"
  end

  test "Cleans up the showcase blocks for newline content" do
    blocks = [{usage_showcase: "\n<div></div>\n", title:"\ntitle"}, {usage_showcase: "\n<h2>\n</h2>", summary:"\nsummary"}]
    blocks = @parser.tidy_showcase blocks
    assert_equal blocks[0][:usage_showcase], "<div></div>\n"
    assert_equal blocks[0][:title], "\ntitle"
    assert_equal blocks[1][:usage_showcase], "<h2>\n</h2>"
    assert_equal blocks[1][:summary], "\nsummary"
  end

  test "Handles a markdown file of handing it's contents to the raw tag" do
    @mkd = @parser.parse({file:"./test/fixtures/markdown/markdown.md", template:"raw.mustache"})
    assert_includes @mkd[:raw], "Markdown Test File"
    assert_equal @mkd[:title], "Markdown"
    assert_equal @mkd[:filepath], "./test/fixtures/markdown/markdown.md"
    assert_empty @mkd[:subnav]
    assert_empty @mkd[:sherpas]
  end

end

