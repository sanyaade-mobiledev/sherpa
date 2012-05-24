
require 'helper'

class ManifestTest < Sherpa::Test

  def setup
    @base_dir = "./test/fixtures/"
    @template = "raw.mustache"
  end

  test "Generates a manifest from a require_tree directive" do
    items = [{"require_tree"=>"sass/"}]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []
    manifest.files.each do |file|
      files.push file[:file]
      assert_includes file, :template
    end
    assert_includes files, "#{@base_dir}sass/visibility.sass"
    assert_includes files, "#{@base_dir}sass/base/headings.sass"
    assert_includes files, "#{@base_dir}sass/mixins/font-size.sass"
  end

  test "Generates a manifest from a require_tree directive while overiding the template" do
    items = [{"require_tree"=>"sass/", "template"=>"section.mustache"}]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []
    manifest.files.each do |file|
      files.push file[:file]
      assert_equal file[:template], "section.mustache"
    end
    assert_includes files, "#{@base_dir}sass/visibility.sass"
    assert_includes files, "#{@base_dir}sass/base/headings.sass"
    assert_includes files, "#{@base_dir}sass/mixins/font-size.sass"
  end

  test "Generates a manifest from a require directive" do
    items = [{"require"=>"**/*.{js,coffee}"}]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []
    manifest.files.each do |file|
      files.push file[:file]
      assert_includes file, :template
    end
    assert_includes files, "#{@base_dir}coffee/coffee.coffee"
    assert_includes files, "#{@base_dir}javascript/javascript.js"
  end

  test "Generates a manifest from a require directive overriden the default template" do
    items = [{"require"=>"**/*.{js,coffee}", "template"=>"section.mustache"}]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []
    manifest.files.each do |file|
      files.push file[:file]
      assert_equal file[:template], "section.mustache"
    end
    assert_includes files, "#{@base_dir}coffee/coffee.coffee"
    assert_includes files, "#{@base_dir}javascript/javascript.js"
  end

  test "Generates a manifest from a require directive for images" do
    items = [{"require"=>"**/*.{png,jpeg,jpg,gif,ico}"}]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []

    manifest.files.each do |file|
      files.push file[:file]
      assert_includes file, :template
    end

    assert_includes files, "#{@base_dir}images/apple-touch-icon-114x114-precomposed.png"
    assert_includes files, "#{@base_dir}images/favicon.ico"
  end

  test "Generates a manifest from a require file" do
    items = [{"require" => "css/links.css"}]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []
    manifest.files.each do |file|
      files.push file[:file]
      assert_includes file, :template
    end
    assert_includes files, "#{@base_dir}css/links.css"
  end

  test "Generates a manifest from a listing of file objects" do
    items = [
      {"require"=>"css/links.css", "template"=>"raw.mustache"},
      {"require"=>"ruby/ruby.rb", "template"=>"raw.mustache"}
    ]
    manifest = Sherpa::Manifest.new(@base_dir, @template, items)
    files = []
    manifest.files.each do |file|
      files.push file[:file]
      assert_includes file, :template
    end
    assert_includes files, "#{@base_dir}ruby/ruby.rb"
    assert_includes files, "#{@base_dir}css/links.css"
  end

end

