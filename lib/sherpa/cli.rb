
require 'optparse'

module Sherpa
  class CLI
    attr_accessor :input,
                  :html_output,
                  :json_output,
                  :mkd_output,
                  :mkds_output,
                  :output_dir,
                  :debug,
                  :options

    def initialize(args)
      self.input = ""
      self.html_output = false
      self.json_output = false
      self.mkd_output = false
      self.mkds_output = false
      self.debug = false
      self.options = {}
      args.options { |o|
        o.on("-i", "--input=FILE")  { |file| self.input += file }
        o.on("--html")              { |value| self.html_output = true }
        o.on("--json")              { |value| self.json_output = true }
        o.on("--markdown")          { |value| self.mkd_output = true }
        o.on("--markdown-sections") { |value| self.mkds_output = true }
        o.on("-d", "--debug")       { |value| self.debug = true }
        o.on_tail("-h", "--help")   { usage(args) }
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
      if %w(json yml yaml).include?(filetype)
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
      output = blocks[:settings]["output_dir"]
      output_dir = output =~ %r(/$) ? output : "#{output}/"
      save_layouts blocks if html_output
      save_as_markdown(blocks, output_dir) if mkd_output
      save_sections_as_markdown(blocks, output_dir) if mkds_output
      save_as_json(blocks, output_dir) if json_output
      0
    end

    # render the sherpa layout
    def save_layouts(blocks)
      layout = Sherpa::Layout.new blocks
      layout.render_and_save
    end

    # export to json
    def save_as_json(blocks, output_dir)
      blocks.delete_if {|key| key.to_s == "settings"}
      json = JSON.pretty_generate(blocks)

      File.open("#{output_dir}sherpa.json", "w") do |file|
        file.write(json)
      end
    end

    # Saves a single markdown file based from the raw blocks
    def save_as_markdown(blocks, output_dir)
      mkd = ""
      blocks.each do |key, value|
        if key.to_s != "settings"
          value.each do |definition|
            mkd += definition[:raw]
          end
        end
      end
      File.open("#{output_dir}sherpa.md", "w") do |file|
        file.write(mkd)
      end
    end

    def save_sections_as_markdown(blocks, output_dir)
      pages = {}
      blocks.each do |key, value|
        if key.to_s != "settings"
          mkd = ""
          value.each do |definition|
            mkd += definition[:raw]
          end
          pages[key] = mkd
        end
      end
      render_sections_to_markdown pages, output_dir
    end

    def render_sections_to_markdown(pages, output_dir)
      pages.each do |key, value|
        File.open("#{output_dir}#{key}.md", "w") do |file|
          file.write(value)
        end
      end
    end

  end
end

