
require 'mustache'

module Sherpa
  class Layout

    def initialize(config, blocks)
      @config = config
      @blocks = blocks
      inherit_settings()
    end

    def inherit_settings
      settings = @config["settings"]
      output_dir = settings["output_dir"] || "./"
      layout_dir = settings["layout_dir"] || "./lib/layouts/"
      layout_template = settings["layout_template"] || "layout.mustache"
      section_template = settings["section_template"] || "raw.mustache"

      @config.each do |key, value|
        if key != "settings"
          value["output_dir"] = output_dir if value["output_dir"].nil?
          value["layout_dir"] = layout_dir if value["layout_dir"].nil?
          value["layout_template"] = layout_template if value["layout_template"].nil?
          value["section_template"] = section_template if value["section_template"].nil?
        end
      end
    end

    def set_options(key)
      @base_dir = @config[key]["base_dir"]
      @output_dir = @config[key]["output_dir"]
      @layout_dir = @config[key]["layout_dir"]
      @layout_template = File.join(@layout_dir, @config[key]["layout_template"])
      @section_template = File.join(@layout_dir, @config[key]["section_template"])

      @stache_layout = File.read(@layout_template)
      @stache_section = File.read(@section_template)
    end

    def render_and_save
      render_primary_nav
      @blocks.each do |key, value|
        if key.to_s != "deets"
          set_options key
          render key, value
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

    def render(name, blocks)
      @html = ""
      @aside_nav = ""
      section = nil
      repo = @config["settings"]["repo"]

      blocks.each do |key|
        key.each do |keys, block|
          raw = block[:raw]
          markup = block[:markup]
          title = block[:title]
          subnav = block[:subnav]
          repo_url = "#{repo}#{block[:filepath].gsub(/^\./, 'blob/master')}"
          filepath = Utils.pretty_path(@base_dir, block[:filepath])
          id = Utils.uid(filepath).gsub(/_/, '-')
          sherpas = block[:sherpas]
          cur_section = !!(filepath =~ /\//) ? filepath.split('/')[0] : "root"

          if cur_section != section
            section = cur_section
            @aside_nav += "<li class='sherpa-nav-header'>#{section.capitalize}</li>"
          end
          @aside_nav += "<li><a href='##{id}'>#{block[:title]}</a></li>"
          if !subnav.empty?
            subnav.each_with_index do |item, n|
              link_id = "#{id}-#{item}"
              @aside_nav += "<li class='sherpa-subnav'><a href='##{link_id}'>#{item}</a></li>"
              block[:sherpas][n + 1][:id] = "#{link_id}"
            end
          end
          @html += Mustache.render(@stache_section, raw: raw, markup: markup, title: title, filepath: filepath, sherpas: sherpas, id: id, repo_url: repo_url)
        end
      end
    end

    def save_markup(key)
      title = @config["settings"]["title"]
      layout = Mustache.render(@stache_layout, title: title, nav: @main_nav, aside: @aside_nav, layout: @html, deets: @blocks[:deets])
      File.open("#{@output_dir}#{key}.html", "w") do |file|
        file.write(layout)
      end
    end

  end
end

