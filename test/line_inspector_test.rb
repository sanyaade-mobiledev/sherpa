
require 'helper'

class LineInspectorTest < Sherpa::Test

  def setup
    @inspector = Sherpa::Parsing::LineInspector
  end

  test "If the current line is the start of a sherpa block" do
    slash = "//~"
    pound = "#~"
    comment = "// a comment"
    multi = "/*~"
    javadoc = "  /**~"
    multi_none = "/**"
    normal = "This is a normal line"
    assert @inspector.sherpa_block?(slash)
    assert @inspector.sherpa_block?(pound)
    assert @inspector.sherpa_block?(multi)
    assert @inspector.sherpa_block?(javadoc)
    refute @inspector.sherpa_block?(comment)
    refute @inspector.sherpa_block?(normal)
    refute @inspector.sherpa_block?(multi_none)
  end

  test "If the current line is a comment marker for supported languages" do
    sherpa = "//~ "
    slash = "// comment"
    pound = "# comment"
    multi = "* comment"
    normal = "This is a normal line"
    assert @inspector.line_comment?(sherpa)
    assert @inspector.line_comment?(slash)
    assert @inspector.line_comment?(pound)
    assert @inspector.line_comment?(multi)
    refute @inspector.line_comment?(normal)
  end

  test "If the current line is a multi comment start" do
    assert @inspector.multi_comment_start?("/*~ Some text */")
    assert @inspector.multi_comment_start?("/**~")
  end

  test "If the current line is the end of a multi comment marker" do
    assert @inspector.multi_comment_end?("/*~ Some text */")
    assert @inspector.multi_comment_end?("*/")
    assert @inspector.multi_comment_end?("  */")
    refute @inspector.multi_comment_end?("*")
    refute @inspector.multi_comment_end?("/")
  end

  test "If the current line is a pre tag" do
    pre = "    pre line"
    sub_pre = "      pre line"
    normal = "  pre line"
    really = "    <p class='decal'>Default</p>"
    assert @inspector.pre_line?(pre)
    assert @inspector.pre_line?(sub_pre)
    refute @inspector.pre_line?(normal)
    assert @inspector.pre_line?(really)
  end

  test "If the current line is a sherpa section" do
    assert @inspector.sherpa_section?("Section:")
    assert @inspector.sherpa_section?("## Section:")
    refute @inspector.sherpa_section?("Section")
  end

  test "If the current line is a markdown header" do
    assert @inspector.markdown_header?("# Markdown")
    assert @inspector.markdown_header?("## Markdown")
    assert @inspector.markdown_header?("###Markdown")
    refute @inspector.markdown_header?("Markdown")
    refute @inspector.markdown_header?("")
  end

  test "Check to see if the filetype is markdown" do
    assert @inspector.is_markdown_file?("README.md")
    assert @inspector.is_markdown_file?("./views/README.mkd")
    assert @inspector.is_markdown_file?("./views/README.mdown")
    assert @inspector.is_markdown_file?("./views/README.markdown")
    refute @inspector.is_markdown_file?("./views/README")
    refute @inspector.is_markdown_file?("./views/README.html")
  end

  test "Check to see if the filetype is an image" do
    assert @inspector.is_image_file?("test.png")
    assert @inspector.is_image_file?("test.gif")
    assert @inspector.is_image_file?("test.ico")
    assert @inspector.is_image_file?("test.jpg")
    assert @inspector.is_image_file?("test.jpeg")
    assert @inspector.is_image_file?("test.tiff")
    assert @inspector.is_image_file?("test.tif")
    assert @inspector.is_image_file?("test.pict")
    assert @inspector.is_image_file?("test.pic")
    refute @inspector.is_image_file?("test.pdf")
    refute @inspector.is_image_file?("test.swf")
    refute @inspector.is_image_file?("test.rb")
  end

  test "Check to see if the current line contains an `~lorem` tag" do
    assert @inspector.lorem?("Show me a ~lorem string")
    assert @inspector.lorem?("Show me a ~lorem_medium string")
    assert @inspector.lorem?("Show me a ~lorem_small string")
    assert @inspector.lorem?("Show me a ~lorem_xsmall string")
    assert @inspector.lorem?("Show me a ~lorem_alt string")
  end

  test "Finds the tag type used by an `~lorem` generator" do
    assert_equal @inspector.lorem_type("Show me a ~lorem_xsmall string"), "~lorem_xsmall"
    assert_equal @inspector.lorem_type("Show me a ~lorem_small string"), "~lorem_small"
    assert_equal @inspector.lorem_type("Show me a ~lorem_medium string"), "~lorem_medium"
    assert_equal @inspector.lorem_type("Show me a ~lorem_alt string"), "~lorem_alt"
    assert_equal @inspector.lorem_type("Show me a ~lorem string"), "~lorem"
    assert_equal @inspector.lorem_type("~lorem"), "~lorem"
    refute_equal @inspector.lorem_type("Show me a ~lorem_medium string"), "~lorem"
    refute_equal @inspector.lorem_type("Show me a ~lorem string"), "~lorem_small"
  end

  test "Generates a lorem ipsum string from a `~lorem` tag" do
    xsmall = @inspector.generate_lorem("xsmall: ~lorem_xsmall")
    small = @inspector.generate_lorem("small: ~lorem_small")
    medium = @inspector.generate_lorem("medium: ~lorem_medium")
    alt = @inspector.generate_lorem("alt: ~lorem_alt")
    normal = @inspector.generate_lorem("normal: ~lorem")

    assert_equal xsmall, "xsmall: Lorem ipsum dolor sit amet."
    assert_equal small, "small: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt."
    assert_equal medium, "medium: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation."
    assert_equal alt, "alt: Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
    assert_equal normal, "normal: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  end

  test "Trim off any comment markers for supported languages without trimming whitespace" do
    sherpa = "//~ "
    slash = "// comment"
    pound = "# comment"
    multi = "* comment"
    multi_top = "/**~ comment"
    indented1 = "    # comment"
    indented2 = "  // comment"
    indented3 = "  /* comment"
    indented4 = "  * comment"
    expected = " comment"
    assert_equal @inspector.trim_comment_markers(sherpa), ""
    assert_equal @inspector.trim_comment_markers(slash), expected
    assert_equal @inspector.trim_comment_markers(pound), expected
    assert_equal @inspector.trim_comment_markers(multi), expected
    assert_equal @inspector.trim_comment_markers(multi_top), expected
    assert_equal @inspector.trim_comment_markers(indented1), expected
    assert_equal @inspector.trim_comment_markers(indented2), expected
    assert_equal @inspector.trim_comment_markers(indented3), expected
    assert_equal @inspector.trim_comment_markers(indented4), expected
  end

  test "Trim the left side of a comment block only if the line ends with a trailing lf" do
    new_line = " This is a new line"
    content = "This is pre-existing content\n"
    expected = "This is a new line"
    content_no_trail = "This is pre-existing content"
    pre = "    pre code"
    assert_equal @inspector.trim_left(new_line, content), expected
    assert_equal @inspector.trim_left(pre, content_no_trail), pre
  end

  test "Trim out markdown headers for a plain text title" do
    expected = "Heading"
    assert_equal @inspector.trim_for_title("## Heading"), expected
    assert_equal @inspector.trim_for_title("##Heading"), expected
  end

  test "Trims a trailing colon from a line" do
    expected = "Heading"
    assert_equal @inspector.trim_colon("Heading:"), expected
  end

  test "Converts a sherpa section into a key" do
    assert_equal @inspector.trim_sherpa_section_for_key("### Section: "), "section"
    assert_equal @inspector.trim_sherpa_section_for_key("### Section Key: "), "section_key"
    assert_equal @inspector.trim_sherpa_section_for_key("## Section Key: "), "section_key"
  end

  test "Turns a sherpa section into a markdown h4 unless the line is already a markdown header" do
    assert_equal @inspector.add_markdown_header("Heading:"), "#### Heading:\n"
    assert_equal @inspector.add_markdown_header("## Heading:"), "## Heading:"
  end

end

