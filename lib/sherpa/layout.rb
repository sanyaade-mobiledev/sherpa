
require 'mustache'

module Sherpa
  class Layout

    def initialize(config, blocks)
      @config = config
      @blocks = blocks
    end

    def set_options(key)
      @base_dir = @config[key]["base_dir"]
      @output_dir = @config[key]["output_dir"]
      @layout_dir = @config[key]["layout_dir"] || "./lib/layouts/"
      @layout_template = File.join(@layout_dir, @config[key]["layout_template"] || "layout.mustache")
      @section_template = File.join(@layout_dir, @config[key]["section_template"] || "raw.mustache")

      @stache_layout = File.read(@layout_template)
      @stache_section = File.read(@section_template)
    end

    def render_and_save
      render_primary_nav
      @blocks.each do |key, value|
        if key.to_s != "deets"
          set_options key
          render value
          save_markup key
        end
      end
    end

    def render_primary_nav
      @main_nav = ""
      @blocks.each do |key, value|
        if key.to_s != "deets"
          @main_nav += "<li><a href='/#{key}.html'>#{key.capitalize}</a></li>"
        end
      end
    end

    def render(blocks)
      @html = ""
      @aside_nav = ""
      @current_path = ""
      @current_section = ""

      blocks.each do |block|
        block.each do |key, sections|
          sections.each_with_index do |section, x|
            path = SherpaUtils.pretty_path(@base_dir, section[:filepath])
            name = File.basename(path,File.extname(path))
            cur_section = !!(path =~ /\//) ? path.split('/')[0] : "root"
            id = "#{cur_section}-#{name}#{x > 0 ? "_#{x}": ""}"

            section[:filepath] = path
            section[:id] = id

            if cur_section != @current_section
              @current_section = cur_section
              @aside_nav += "<li class='sherpa-nav-header'>#{@current_section.capitalize}</li>"
            end

            if path != @current_path
              @current_path = path
              @aside_nav += "<li><a href='##{id}'>#{name.capitalize}</a></li>"
            else
              section[:filepath] = nil
            end
            @html += Mustache.render(@stache_section, :blocks => section)
          end
        end
      end
    end

    def save_markup(key)
      layout = Mustache.render(@stache_layout, :nav => @main_nav, :aside => @aside_nav, :layout => @html, :deets => @blocks[:deets])
      File.open("#{@output_dir}#{key}.html", "w") do |file|
        file.write(layout)
      end
    end

  end
end

