
module Sherpa
  class Builder

    def initialize(config)
      @files = get_manifest(config["manifest"], config['base_dir'])
      @output = {}
      @output[:sherpas] = []
      @output[:deets] = {}
      @parser = Sherpa::Parser.new
      @renderer = Sherpa::Renderer.new
    end

    def build
      @files.each do |file|
        file_blocks = @parser.parse(file)
        file_blocks = @renderer.render_blocks(file_blocks)
        @output[:sherpas].push(file_blocks)
      end
      @output[:deets] = publish_deets
      @output
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
