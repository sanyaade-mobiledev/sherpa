
require 'helper'
require 'sherpa/cli'

class CLITest < Sherpa::Test

  def setup
    args = ["-i", "./test/config/config.yaml"]
    args.extend(::OptionParser::Arguable)
    @cli = Sherpa::CLI.new(args)
  end

  test "Options" do
    assert_equal @cli.input, "./test/config/config.yaml"
  end

  test "Has a configuration" do
    assert_includes @cli.config["settings"]["title"], "sherpa"
  end

  test "Exits with 0 after calling run" do
    assert_equal @cli.run, 0
  end
end

