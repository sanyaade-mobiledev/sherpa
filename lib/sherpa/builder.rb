
module Sherpa
  class Builder

    def initialize(files)
      @files = find_files(files)
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

    # Candidate for Utils
    def filetype?(filename)
      File.extname(filename).gsub(/\./, "")
    end

    def find_files(file_or_files)
      # This is a file so we need to know what kind, load it and find the file list before returning
      if file_or_files.kind_of? String
        filetype = filetype?(file_or_files)
        raise "unsupported filetype for .#{filetype}" unless filetype == 'json' || filetype == 'yaml'
        config = (filetype == 'json') ? JSON.parse(File.read(file_or_files)) : YAML.load(File.read(file_or_files))
        return find_manifest(config["manifest"])

      # It's already a listing of files so just send it back
      elsif file_or_files.kind_of? Array
        return file_or_files

      # We don't know WTF to do with it
      else
        raise "not sure what to do with: #{file_or_files}"
      end
    end

    # Find either the array or object containing the file listing
    def find_manifest(manifest)
      if manifest[0].kind_of? String
        return manifest
      elsif manifest[0].kind_of? Hash
        files = []
        manifest.each do |file|
          files.push(file["file"])
        end
        return files
      else
        raise "your manifest is not right, expects either an array or hash"
      end
    end

  end
end

