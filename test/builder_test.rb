
require './test/helper'

class BuilderTest < Sherpa::Test

  def setup
    @config = YAML.load(File.read('./test/config/config.yaml'))
    @builder = Sherpa::Builder.new @config
  end

  test "Builds an object from a configuration file" do
    output = @builder.build
    assert_includes output["overview"][0], "README"
    assert_includes output["overview"][0]["README"], :raw
    assert_includes output["overview"][0]["README"], :markup
    assert_includes output["test"][0], "test_fixtures_sass_mixins_font-size"
    assert_includes output["test"][0]["test_fixtures_sass_mixins_font-size"], :raw
    assert_includes output["test"][0]["test_fixtures_sass_mixins_font-size"], :markup
  end

  test "Builds a section from a test file from overview" do
    output = @builder.build_section @config["overview"]
    assert_includes output[0], "README"
    assert_includes output[0]["README"], :raw
    assert_includes output[0]["README"], :markup
    assert_includes output[0]["README"], :base_dir
  end

  test "Builds a section from a listing of files" do
    output = @builder.build_section @config["test"]
    item = output[0]["test_fixtures_sass_mixins_font-size"]
    assert_includes output[0], "test_fixtures_sass_mixins_font-size"
    assert_includes item, :raw
    assert_equal item[:base_dir], "./test/fixtures/"
  end

  test "Builds a section from a glob of files" do
    output = @builder.build_section @config["globs"]
    keys = []
    output.each do |key|
      key.each do |value|
        keys.push value[0]
      end
    end
    assert_includes keys, "test_fixtures_sass_mixins_font-size"
    assert_includes keys, "test_fixtures_sass_visibility"
    assert_includes keys, "test_fixtures_javascript_javascript"
    assert_includes keys, "test_fixtures_coffee_coffee"
    assert_includes keys, "test_fixtures_markdown_markdown"
    assert_includes keys, "test_fixtures_css_links"
    assert_includes keys, "test_fixtures_ruby_ruby"
  end

end

