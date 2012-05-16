require 'optparse'

module Sherpa
  class CLI
    attr_accessor :input, :debug, :options

    def initialize
      self.input = "./"
      self.debug = false
      self.options = {}
      ARGV.options { |o|
        o.on("-i", "--input=FILE") { |file| self.input += file }
        o.on("-d", "--debug")      { |value| self.debug = true }
        o.on_tail("-h", "--help")  { usage }
        o.parse!
      } or abort_with_note

      run
    end

    def usage
      puts ARGV.options
      abort
    end

    def abort_with_note(message=nil)
      $stderr.puts message if message
      abort "See `sherpa --help' for usage information."
    end

    def config
      return @config if @config
      # Load the configuration file
      filetype = File.extname(input).gsub(/\./, "")
      if filetype == 'json' || filetype == 'yaml'
        @config = (filetype == 'json') ? JSON.parse(File.read(input)) : YAML.load(File.read(input))
      else
        abort_with_note("Sherpa requires a .json or .yaml config file")
      end
      @config
    end

    def run
      # Send out for the build
      builder = Sherpa::Builder.new(config)
      blocks = builder.build

      abort_with_note "No blocks found!" unless blocks

      # Render outputs
      output_dir = config["settings"]["output_dir"]
      json = JSON.pretty_generate(blocks)
      puts json unless debug == false

      File.open("#{output_dir}sherpa.json", "w") do |file|
        file.write(json)
      end

      layout = Sherpa::Layout.new("#{output_dir}sherpa.json")
      layout.render_and_save
    end
  end
end
