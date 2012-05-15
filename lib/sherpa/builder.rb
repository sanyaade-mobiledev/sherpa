
#~
# The builder is the hub for reading a configuration and looking for files
# that need to be parsed into sherpa blocks.

module Sherpa
  class Builder

    def initialize(config)
      @config = config
      @base_dir = config["settings"]["base_dir"] || "./"
      @base_template = config["settings"]["default_section_template"] || nil
      @output = nil
      @parser = Sherpa::Parser.new
      @renderer = Sherpa::Renderer.new
    end

    def build
      @output = {settings: @config["settings"]}
      @config.each do |key, value|
        unless key == "settings"
          @output[key] = build_section value
        end
      end
      @output
    end

    def build_section(section)
      outputs = []
      base_dir = section["base_dir"] || @base_dir
      template = section["section_template"] || @base_template

      manifest = Manifest.new(base_dir, template, section['manifest'])

      manifest.files.each do |file|
        output = {}
        file_blocks = @parser.parse(file)
        file_blocks = @renderer.render_blocks(file_blocks)
        file_blocks[:base_dir] = base_dir
        output[Utils.uid(file[:file])] = file_blocks
        outputs.push output
      end
      outputs
    end

  end
end

