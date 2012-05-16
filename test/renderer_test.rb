
require 'helper'

class RendererTest < Sherpa::Test

  def setup
    @renderer = Sherpa::Renderer.new
  end

  test "Test sherpa gsub from redcarpet render" do
    assert_equal @renderer.render("## Hello World"), "<h2>Hello World</h2>\n"
  end


  test "Renders blocks into markdown" do
    summary = "The Summary"
    usage_showcase = "showcase not converted"
    title = "title not converted"
    raw = "# Title \nThe Summary"
    markup = "<h1>Title</h1>\n<br /><p>The Summary</p>"
    block = {:raw=>raw, :markup=>"", :sherpas=>[{"summary"=>"", :title=>title, :usage_showcase=>usage_showcase}]}

    result = @renderer.render_blocks block
    assert_equal result[:raw], raw
    assert_includes result[:markup], "<h1>Title</h1>"
    assert_includes result[:markup], "<br /><p>The Summary</p>"
    assert_equal result[:sherpas][0][:title], title
    assert_equal result[:sherpas][0][:usage_showcase], usage_showcase
  end

end

