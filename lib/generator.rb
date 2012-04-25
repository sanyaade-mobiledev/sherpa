
require 'json'
require './lib/sherpa'

module Sherpa
  class Generator

    def initialize
      config = JSON.parse(File.read("./sherpa.json"))
      root_dir = config["root_dir"]
      layout_dir = config["layout_dir"]
      default_template = config["default_template"]
      manifest = config["manifest"]

      manifest.each do |man|
        file = man["file"]
        tmpl = man["template"]
        man["file"] = "#{root_dir}#{file}"
        if tmpl
          man["template"] = "#{layout_dir}#{tmpl}"
        else
          man["template"] = "#{layout_dir}#{default_template}"
        end
      end

      # puts manifest

      builder = Builder.new(manifest, false)
      builder.build
      # builder.output
    end

  end
  generator = Generator.new
end

