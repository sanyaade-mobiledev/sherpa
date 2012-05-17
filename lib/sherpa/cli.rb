
require 'optparse'

module Sherpa
  class CLI
    attr_accessor :input,
                  :debug,
                  :options

    def initialize(args)
      # puts args
      self.input = ""
      self.debug = false
      self.options = {}
      args.options { |o|
        o.on("-i", "--input=FILE") { |file| self.input += file }
        o.on("-d", "--debug")      { |value| self.debug = true }
        o.on_tail("-h", "--help")  { usage }
        o.parse!
      } or abort_with_note
      run
    end

    def usage
      puts args.options
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
        abort_with_note "Sherpa requires a .json or .yaml config file"
      end
      @config
    end

    def run
      # Send out for the build
      builder = Sherpa::Builder.new(config)
      blocks = builder.build

      abort_with_note "No blocks found!" unless blocks
      puts JSON.pretty_generate(blocks) unless debug == false

      # Render outputs
      save_layouts blocks
      # save_as_json blocks
      # save_single_markdown blocks
      0
    end

    def save_layouts(blocks)
      layout = Sherpa::Layout.new blocks
      layout.render_and_save
    end

    def save_as_json(blocks)
      json = JSON.pretty_generate(blocks)

      File.open("#{blocks[:settings]["output_dir"]}sherpa.json", "w") do |file|
        file.write(json)
      end
    end

    def save_single_markdown(blocks)
      mkd = ""
      blocks.each do |key, value|
        if key.to_s != "settings"
          value.each do |definition|
            mkd += definition[:raw]
          end
        end
      end
      File.open("#{blocks[:settings]["output_dir"]}sherpa.md", "w") do |file|
        file.write(mkd)
      end
    end

  end
end

