
require 'helper'

class LayoutTest < Sherpa::Test

  def setup
    @config = YAML.load(File.read('./test/config/config.yml'))
    @blocks = Sherpa::Builder.new(@config).build
    @layout = Sherpa::Layout.new(@blocks)
  end

  test "Sets default global settings based on the config file" do
    assert_equal @layout.output_dir, "./test/views/"
    assert_equal @layout.layout_dir, "./lib/layouts/"
    assert_equal @layout.stache_layout, File.read(File.join(@layout.layout_dir, @config["settings"]["layout_template"]))
  end

  test "Preloads all templates found in a config file" do
    assert_equal @layout.templates.size, 4
    assert_equal @layout.templates['raw_mustache'], File.read(File.join(@layout.layout_dir, "raw.mustache"))
    assert_equal @layout.templates['section_mustache'], File.read(File.join(@layout.layout_dir, "section.mustache"))
  end

  test "Does not add a template if one with the same key already exists" do
    @layout.add_template('raw.mustache')
    assert_equal @layout.templates.size, 4
  end

  test "Adds a template if one does not already exists" do
    @layout.add_template('new.mustache')
    assert_equal @layout.templates.size, 5
    assert @layout.templates["new_mustache"]
  end

  test "Concatenates a list of primary nav elements based off sections from sherpa documents" do
    assert_includes @layout.render_primary_nav, "Overview"
    assert_includes @layout.render_primary_nav, "Test"
    assert_includes @layout.render_primary_nav, "Globs"
    assert_includes @layout.render_primary_nav, "<a href"
  end

  test "Renders an aside navigation for a given sherpa block" do
    key = "test"
    value = @blocks[key]
    result = @layout.render_page value

    assert_includes result[:aside], "<li class='sherpa-nav-header'>"
    assert_includes result[:aside], "<li><a href="
    assert_includes result[:aside], "<li class='sherpa-subnav"
    assert_includes result[:aside], "Headings"
  end

  test "Renders an html string for a given sherpa block" do
    key = "test"
    value = @blocks[key]
    result = @layout.render_page value

    assert_includes result[:html], "blob"
    assert_includes result[:html], "headings.sass"
    assert_includes result[:html], "<section"
  end

  test "Generates a unique ID for use in identification and anchor tags from a filepath" do
    path1 = "./app/assets/base.css"
    path2 = "./README.md"
    assert_equal @layout.uid(path1), "app_assets_base"
    assert_equal @layout.uid(path2), "README"
  end

  test "Returns the filename and parent directories stripped from a base directory" do
    base = "app/assets/stylesheets/"
    root = "app/assets/stylesheets/base.sass"
    components = "app/assets/stylesheets/components/base.sass"
    nested = "app/assets/stylesheets/components/nested/base.sass"
    assert_equal @layout.pretty_path(base,root), "base.sass"
    assert_equal @layout.pretty_path(base,components), "components/base.sass"
    assert_equal @layout.pretty_path(base,nested), "components/nested/base.sass"
  end

  test "Gets a section path for a key and heading" do
    base_dir = "test/fixtures"
    section_path = "sass/mixins/font-size.sass"
    for_base = ""
    assert_equal @layout.get_section_path(section_path, base_dir), "sass"
    assert_equal @layout.get_section_path(for_base, base_dir), "fixtures"
  end

end

