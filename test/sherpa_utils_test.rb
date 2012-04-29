
require './test/helper'

class SherpaUtilsTest < Sherpa::Test

  def setup
    @utils = Sherpa::SherpaUtils
  end

  test "Retrieves a filetype" do
    assert_equal @utils.filetype?('base.sass'), "sass"
  end

end

