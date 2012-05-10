
#~
# The builder is the hub for reading a configuration and looking for files
# that need to be parsed into sherpa blocks.

module Sherpa
  class Builder

    def initialize(config)
      @config = config
      @output = nil
      @parser = Sherpa::Parser.new
      @renderer = Sherpa::Renderer.new
    end

    def build
      @output = {}
      @config.each do |key, value|
        @output[key] = build_section value unless key == "settings"
      end
      @output
    end

    def build_section(config)
      outputs = []
      files = get_manifest(config["manifest"], config["base_dir"] )
      files.each do |file|
        output = {}
        file_blocks = @parser.parse(file)
        file_blocks = @renderer.render_blocks(file_blocks)
        output[Utils.uid(file)] = file_blocks
        outputs.push output
      end
      outputs
    end

    def get_manifest(manifest, base_dir)
      base = base_dir || ""
      files = []
      if manifest.is_a? String
        globbed = Dir["#{base}/**/*#{manifest}"]
        globbed.each do |f|
          files.push f
        end
      else
        # If the manifest is a listing of files..
        if manifest[0].is_a? String
          manifest.each do |file|
            files.push("#{base}#{file}")
          end

        # If the manifest is a listing of objects..
        elsif manifest[0].is_a? Hash
          manifest.each do |file|
            files.push("#{base}#{file['file']}")
          end
        else
          raise "Couldn't find the manifest of files."
        end
      end
      return files
    end

  end
end

