
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

  test "Builds a section from a test file" do
    output = @builder.build_section @config["overview"]
    assert_includes output[0], "README"
    assert_includes output[0]["README"], :raw
    assert_includes output[0]["README"], :markup
  end

  test "Gets a manifest of files from a flat array" do
    files = @builder.get_manifest(@config["overview"]["manifest"], "./")
    assert_equal files, ["./README.md"]
  end

  test "Gets a manifest of files in a nested object" do
    files = @builder.get_manifest(@config["test"]["manifest"], "./")
    assert_includes files, "./coffee/coffee.coffee"
  end

  test "Gets a manifest of files from a glob" do
    files = @builder.get_manifest(@config["globs"]["manifest"], "./test/fixtures/sass/")
    assert_includes files, "./test/fixtures/sass//base/headings.sass"
  end

end

