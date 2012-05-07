
require './test/helper'

class LayoutTest < Sherpa::Test

  def setup
    @config = YAML.load(File.read('./test/fixtures/config/config.yaml'))
    @layout = Sherpa::Layout.new(@config, nil)
  end

  test "Sets default global settings based on the config file" do
    assert_equal @layout.output_dir, "./example/app/views/sherpa/"
    assert_equal @layout.layout_dir, "./lib/layouts/"
    assert_equal @layout.stache_layout, File.read(File.join(@layout.layout_dir, @config["settings"]["layout_template"]))
  end

  test "Sets section templates based on a default template unless one already exists" do
    assert_equal @layout.config["overview"]["section_template"], 'raw.mustache'
    assert_equal @layout.config["test"]["section_template"], 'section.mustache'
  end

  test "Preloads all templates found in a config file" do
    assert_equal @layout.templates.size, 2
    assert_equal @layout.templates['raw_mustache'], File.read(File.join(@layout.layout_dir, "raw.mustache"))
    assert_equal @layout.templates['section_mustache'], File.read(File.join(@layout.layout_dir, "section.mustache"))
  end

  test "Does not add a template if one with the same key already exists" do
    @layout.add_template('raw.mustache')
    assert_equal @layout.templates.size, 2
  end

  test "Adds a template if one does not already exists" do
    @layout.add_template('new.mustache')
    assert_equal @layout.templates.size, 3
    assert @layout.templates["new_mustache"]
  end

end

