
require 'helper'

class BuilderTest < Sherpa::Test

  def setup
    @config = YAML.load(File.read('./test/config/config.yml'))
    @builder = Sherpa::Builder.new @config
  end

  test "Builds an object from a configuration file" do
    output = @builder.build
    assert_equal output["overview"][0][:filepath], "./README.md"
    assert_includes output["overview"][0], :raw
    assert_includes output["overview"][0], :markup

    assert_equal output["test"][0][:filepath], "./test/fixtures/sass/mixins/font-size.sass"
    assert_includes output["test"][0], :raw
    assert_includes output["test"][0], :markup
  end

  test "Builds a section from a glob of files" do
    output = @builder.build_section @config["globs"]
    files = output.map{|section| section[:filepath]}
    assert_includes files, "./test/fixtures/sass/mixins/font-size.sass"
    assert_includes files, "./test/fixtures/sass/visibility.sass"
    assert_includes files, "./test/fixtures/javascript/javascript.js"
    assert_includes files, "./test/fixtures/coffee/coffee.coffee"
    assert_includes files, "./test/fixtures/markdown/markdown.md"
    assert_includes files, "./test/fixtures/css/links.css"
    assert_includes files, "./test/fixtures/ruby/ruby.rb"
  end

end

