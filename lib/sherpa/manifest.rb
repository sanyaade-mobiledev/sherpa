
module Sherpa
  class Manifest

    attr_accessor :files

    def initialize(base, template, *manifest)
      @files = []
      base_dir = base =~ %r(/$) ? base : "#{base}/"

      manifest.each do |items|
        items.each do |item|

          if item["require_tree"]
            target_directory = item["require_tree"]
            directory = target_directory =~ %r(/$) ? "#{target_directory}**/*.*" : "#{target_directory}/**/*.*"
            path = File.join base_dir, directory
            files = Dir[path]
            files.each do |f|
              tmpl = item["template"] ? item["template"] : template
              @files.push({file: f, template: tmpl})
            end
          end

          if item["require"]
            target_files = item["require"]
            path = File.join base_dir, target_files
            files = Dir[path]
            files.each do |f|
              tmpl = item["template"] ? item["template"] : template
              @files.push({file: f, template: tmpl})
            end
          end
        end

      end
    end

  end
end

