
require './test/helper'

class SherpaUtilsTest < Sherpa::Test

  def setup
    @utils = Sherpa::SherpaUtils
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

