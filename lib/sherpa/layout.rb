
require 'mustache'

module Sherpa
  class Layout

    def initialize(config)
      @html = ""
      @blocks = nil
      @config = config

      @layout_dir = @config["layout_dir"] || "./lib/layouts/"
      @layout_template = File.join(@layout_dir, @config["layout_template"] || "layout.mustache")
      @section_template = File.join(@layout_dir, @config["section_template"] || "raw.mustache")

      @stache_layout = File.read(@layout_template)
      @stache_section = File.read(@section_template)
    end

    def render_and_save(blocks)
      @blocks = blocks
      render
      save_markup
    end

    def render
      @blocks[:sherpas].each do |block|
        block.each do |section|
          @html += Mustache.render(@stache_section, :blocks => section)
        end
      end
    end

    def save_markup
      deets = @blocks[:deets]
      layout = Mustache.render(@stache_layout, :layout => @html, :deets => deets)
      File.open('./index.html', "w") do |file|
        file.write(layout)
      end
    end

  end
end

