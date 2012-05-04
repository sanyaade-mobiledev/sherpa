
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
      @output[:deets] = publish_deets
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

    def publish_deets
      published = {}
      published[:published_at] = Time.now.strftime("%m/%d/%Y %I:%M%P %Z")
      published[:published_by] = `git config user.name`.gsub(/\n/, "")
      published
    end

    def get_manifest(manifest, base_dir)
      base = base_dir || ""
      files = []

      # If the manifest is a listing of files..
      if manifest[0].kind_of? String
        manifest.each do |file|
          files.push("#{base}#{file}")
        end

      # If the manifest is a listing of objects..
      elsif manifest[0].kind_of? Hash
        manifest.each do |file|
          files.push("#{base}#{file['file']}")
        end
      else
        raise "Couldn't find the manifest of files."
      end
      return files
    end

  end
end

