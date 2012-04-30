
require './test/helper'

class SherpaUtilsTest < Sherpa::Test

  def setup
    @utils = Sherpa::SherpaUtils
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

  # TODO: headers should also be able to be denoted as just markdown
  test "If the current line is a header" do
    assert @utils.header?("Header:")
    assert @utils.header?("## Header:")
    # assert @utils.header?("## Header")
    refute @utils.header?("Header")
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

  test "Converts a markdown header into a key" do
    assert_equal @utils.trim_header_for_key("### Heading: "), "heading"
    assert_equal @utils.trim_header_for_key("### Heading Key: "), "heading_key"
    assert_equal @utils.trim_header_for_key("## Heading Key: "), "heading_key"
  end

  test "Turns a line into a markdown h3 unless the line is already a markdown header" do
    assert_equal @utils.add_markdown_header("Heading:"), "### Heading:\n"
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

  test "Retrieves the extension name from file less the dot" do
    assert_equal @utils.filetype?("base.sass"), "sass"
    assert_equal @utils.filetype?("components/base.sass"), "sass"
    assert_equal @utils.filetype?("components/base.css.sass"), "sass"
  end

end

