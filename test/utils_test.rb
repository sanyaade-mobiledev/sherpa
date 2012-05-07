
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

