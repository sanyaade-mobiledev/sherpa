
module Sherpa
  class Sources

    def initialize()
    end

    def find_files(file_or_files)
      # This is a file so we need to know what kind, load it and find the file list before returning
      if file_or_files.kind_of? String
        filetype = SherpaUtils.filetype?(file_or_files)
        raise "Unsupported filetype for .#{filetype}" unless filetype == 'json' || filetype == 'yaml'
        config = (filetype == 'json') ? JSON.parse(File.read(file_or_files)) : YAML.load(File.read(file_or_files))
        return find_manifest(config["manifest"], config['base_dir'])

      # It's already a listing of files so just send it back
      elsif file_or_files.kind_of? Array
        return file_or_files

      # We don't know WTF to do with it
      else
        raise "not sure what to do with: #{file_or_files}"
      end
    end

    def find_manifest(manifest, base_dir)
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

