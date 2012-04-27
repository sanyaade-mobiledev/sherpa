
require 'mustache'

module Sherpa
  class Layout

    def initialize
      @html = ""
      @stache_layout = File.read('./lib/layouts/layout.mustache')
      @stache_section = File.read('./lib/layouts/raw.mustache')
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
      layout = Mustache.render(@stache_layout, :layout => @html)
      File.open('./index.html', "w") do |file|
        file.write(layout)
      end
    end

  end
end

