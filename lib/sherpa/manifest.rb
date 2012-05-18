
module Sherpa
  class Manifest

    attr_accessor :files

    def initialize(base, template, *manifest)
      @files = []

      manifest.each do |items|
        items.each do |item|

          if item["require_tree"]
            target_directory = item["require_tree"]
            directory = target_directory =~ %r(/$) ? "#{target_directory}**/*.*" : "#{target_directory}/**/*.*"
            path = File.join base, directory
            files = Dir[path]
            files.each do |f|
              @files.push({file: f, template: template})
            end
          end

          if item["require"]
            target_files = item["require"]
            files = Dir["#{base}**/#{target_files}"]
            files.each do |f|
              @files.push({file: f, template: template})
            end
          end

          if item["files"]
            files = item["files"]
            files.each do |f|
              if f["template"]
                @files.push({file: File.join(base, f["file"]), template: f["template"]})
              else
                @files.push({file: File.join(base, f), template: template})
              end
            end
          end
        end

      end
    end

  end
end

