
require './test/helper'

class UtilsTest < Sherpa::Test

  def setup
    @utils = Sherpa::Utils
  end

  test "If the current line is the start of a sherpa block" do
    slash = "//~"
    pound = "#~"
    comment = "// a comment"
    normal = "This is a normal line"
    assert @utils.sherpa_block?(slash)
    assert @utils.sherpa_block?(pound)
    refute @utils.sherpa_block?(comment)
    refute @utils.sherpa_block?(normal)
  end

  test "If the current line is a comment marker for supported languages" do
    sherpa = "//~ "
    slash = "// comment"
    pound = "# comment"
    normal = "This is a normal line"
    assert @utils.line_comment?(sherpa)
    assert @utils.line_comment?(slash)
    assert @utils.line_comment?(pound)
    refute @utils.line_comment?(normal)
  end

  test "If the current line is a pre tag" do
    pre = "    pre line"
    sub_pre = "      pre line"
    normal = "  pre line"
    assert @utils.pre_line?(pre)
    assert @utils.pre_line?(sub_pre)
    refute @utils.pre_line?(normal)
  end

  test "If the current line is a sherpa section" do
    assert @utils.sherpa_section?("Section:")
    assert @utils.sherpa_section?("## Section:")
    refute @utils.sherpa_section?("Section")
  end

  test "If the current line is a markdown header" do
    assert @utils.markdown_header?("# Markdown")
    assert @utils.markdown_header?("## Markdown")
    assert @utils.markdown_header?("###Markdown")
    refute @utils.markdown_header?("Markdown")
    refute @utils.markdown_header?("")
  end

  test "Check to see if the filetype is markdown" do
    assert @utils.is_markdown_file?("README.md")
    assert @utils.is_markdown_file?("./views/README.mkd")
    assert @utils.is_markdown_file?("./views/README.mdown")
    assert @utils.is_markdown_file?("./views/README.markdown")
    refute @utils.is_markdown_file?("./views/README")
    refute @utils.is_markdown_file?("./views/README.html")
  end

  test "Check to see if the current line contains an `~lorem` tag" do
    assert @utils.lorem?("Show me a ~lorem string")
    assert @utils.lorem?("Show me a ~lorem_medium string")
    assert @utils.lorem?("Show me a ~lorem_small string")
    assert @utils.lorem?("Show me a ~lorem_xsmall string")
    assert @utils.lorem?("Show me a ~lorem_alt string")
  end

  test "Finds the tag type used by an `~lorem` generator" do
    assert_equal @utils.lorem_type("Show me a ~lorem_xsmall string"), "~lorem_xsmall"
    assert_equal @utils.lorem_type("Show me a ~lorem_small string"), "~lorem_small"
    assert_equal @utils.lorem_type("Show me a ~lorem_medium string"), "~lorem_medium"
    assert_equal @utils.lorem_type("Show me a ~lorem_alt string"), "~lorem_alt"
    assert_equal @utils.lorem_type("Show me a ~lorem string"), "~lorem"
    assert_equal @utils.lorem_type("~lorem"), "~lorem"
    refute_equal @utils.lorem_type("Show me a ~lorem_medium string"), "~lorem"
    refute_equal @utils.lorem_type("Show me a ~lorem string"), "~lorem_small"
  end

  test "Generates a lorem ipsum string from a `~lorem` tag" do
    xsmall = @utils.generate_lorem("xsmall: ~lorem_xsmall")
    small = @utils.generate_lorem("small: ~lorem_small")
    medium = @utils.generate_lorem("medium: ~lorem_medium")
    alt = @utils.generate_lorem("alt: ~lorem_alt")
    normal = @utils.generate_lorem("normal: ~lorem")

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
    indented = "    # comment"
    expected = " comment"
    assert_equal @utils.trim_comment_markers(sherpa), ""
    assert_equal @utils.trim_comment_markers(slash), expected
    assert_equal @utils.trim_comment_markers(pound), expected
    assert_equal @utils.trim_comment_markers(indented), expected
  end

  test "Trim the left side of a comment block only if the line ends with a trailing lf" do
    new_line = " This is a new line"
    content = "This is pre-existing content\n"
    expected = "This is a new line"
    content_no_trail = "This is pre-existing content"
    pre = "    pre code"
    assert_equal @utils.trim_left(new_line, content), expected
    assert_equal @utils.trim_left(pre, content_no_trail), pre
  end

  test "Trim out markdown headers for a plain text title" do
    expected = "Heading"
    assert_equal @utils.trim_for_title("## Heading"), expected
    assert_equal @utils.trim_for_title("##Heading"), expected
  end

  test "Trims a trailing colon from a line" do
    expected = "Heading"
    assert_equal @utils.trim_colon("Heading:"), expected
  end

  test "Converts a sherpa section into a key" do
    assert_equal @utils.trim_sherpa_section_for_key("### Section: "), "section"
    assert_equal @utils.trim_sherpa_section_for_key("### Section Key: "), "section_key"
    assert_equal @utils.trim_sherpa_section_for_key("## Section Key: "), "section_key"
  end

  test "Generates a unique ID for use in identification and anchor tags from a filepath" do
    path1 = "./app/assets/base.css"
    path2 = "./README.md"
    assert_equal @utils.uid(path1), "app_assets_base"
    assert_equal @utils.uid(path2), "README"
  end

  test "Turns a sherpa section into a markdown h4 unless the line is already a markdown header" do
    assert_equal @utils.add_markdown_header("Heading:"), "#### Heading:\n"
    assert_equal @utils.add_markdown_header("## Heading:"), "## Heading:"
  end

  test "Returns the filename and parent directories stripped from a base directory" do
    base = "app/assets/stylesheets/"
    root = "app/assets/stylesheets/base.sass"
    components = "app/assets/stylesheets/components/base.sass"
    nested = "app/assets/stylesheets/components/nested/base.sass"
    assert_equal @utils.pretty_path(base,root), "base.sass"
    assert_equal @utils.pretty_path(base,components), "components/base.sass"
    assert_equal @utils.pretty_path(base,nested), "components/nested/base.sass"
  end

end

