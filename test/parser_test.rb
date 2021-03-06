
require 'helper'

class ParserTest < Sherpa::Test

  def setup
    @parser = Sherpa::Parser.new
    @definition = @parser.parse({file:"./test/fixtures/sass/base/headings.sass", template:"section.mustache"})
  end

  test "Titleizes a file path" do
    assert_equal @definition.title, "Headings"
  end

  test "Handles a markdown file of handing it's contents to the raw tag" do
    definition = @parser.parse({file:"./test/fixtures/markdown/markdown.md", template:"raw.mustache"})
    assert_includes definition.raw, "Markdown Test File"
    assert_equal definition.title, "Markdown"
    assert_equal definition.filepath, "./test/fixtures/markdown/markdown.md"
    assert_empty definition.subnav
    assert_empty definition.blocks
  end

  test "Handles a markdown file with the Usage term embedded" do
    definition = @parser.parse({file:"./test/fixtures/markdown/code.md", template:"raw.mustache"})
    refute_empty definition.blocks
  end

  test "Handles an image file" do
    definition = @parser.parse({file:"./test/fixtures/images/favicon.ico", template:"raw.mustache"})
    assert_equal definition.raw, "![favicon](/test/fixtures/images/favicon.ico 'favicon')"
    assert_equal definition.filepath, "./test/fixtures/images/favicon.ico"
    assert_equal definition.template, "raw.mustache"
    assert_empty definition.subnav
    assert_empty definition.blocks
  end

  test "Replaces a rails image asset route with the correct path" do
    image_path = @parser.redirect_image_asset("/app/assets/images/image.jpg")
    public_path = @parser.redirect_image_asset("/public/images/image.jpg")
    favicon_path = @parser.redirect_image_asset("/public/favicon.ico")
    js_path = @parser.redirect_image_asset("/app/assets/javascripts/js.js")
    assert_equal image_path, "/assets/image.jpg"
    assert_equal public_path, "/images/image.jpg"
    assert_equal favicon_path, "/favicon.ico"
    assert_equal js_path, "/app/assets/javascripts/js.js"
  end

  test "Handles an unsupported asset file" do
    definition = @parser.parse({file:"./test/fixtures/unsupported/photoshop.psd", template:"raw.mustache"})
    assert definition.raw
    assert_equal definition.filepath, "./test/fixtures/unsupported/photoshop.psd"
    assert_equal definition.template, "raw.mustache"
    assert_empty definition.subnav
    assert_empty definition.blocks
  end

  test "Parses a file and contains the filepath" do
    filepath = @definition.filepath
    assert_equal filepath, "./test/fixtures/sass/base/headings.sass"
  end

  test "Parses a file with sherpa blocks and contains sherpa objects" do
    blocks = @definition.blocks
    assert_equal blocks.size, 2
    assert_includes blocks[0]['summary'], "## Headings"
    assert_includes blocks[0].title, "Headings"
    assert_includes blocks[0].sections[:usage_showcase], "<h1"
    assert_includes blocks[1].title, "h3.alt"
  end

  test "Creates a subnav array for multiple sherpa blocks" do
    subnav = @definition.subnav
    assert_equal subnav, ["h3.alt"]
  end

  test "Returns not in a comment block when the current block is nil" do
    refute @parser.in_block?("", false)
  end

  test "Returns out of a multi line comment block" do
    @parser.current_block = ""
    refute @parser.in_block?("*/", true)
  end

  test "Returns a line within a comment block" do
    @parser.current_block = ""
    assert @parser.in_block?("//", false)
    assert @parser.in_block?("*", false)
    assert @parser.in_block?("#", false)
  end

  test "Normalizes a line by stripping out markers and spacing" do
    line1 = "// Trim Me"
    line2 = "# #Trim Me"
    line3 = "#    Trim Me"
    assert_equal @parser.normalize_line(line1), "Trim Me"
    assert_equal @parser.normalize_line(line2), "#Trim Me"
    assert_equal @parser.normalize_line(line3), "    Trim Me"
  end

  test "Creates a title for a subsequent sherpa block" do
    title = @definition.blocks[1].title
    assert_equal title, "h3.alt"
  end

end

