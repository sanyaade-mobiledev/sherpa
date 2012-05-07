
require 'mustache'

module Sherpa
  class Layout

    attr_accessor :config, :output_dir, :layout_dir, :stache_layout, :templates

    def initialize(config, blocks)
      @config = config
      @blocks = blocks
      @templates = {}
      set_defaults()
      set_section_templates()
      preload_templates()
    end

    # Set default global properties from the settings item
    def set_defaults
      settings = @config["settings"]
      @output_dir = settings["output_dir"] || "./"
      @layout_dir = settings["layout_dir"] || "./lib/layouts/"
      @stache_layout = File.read(File.join(@layout_dir, settings["layout_template"] || "layout.mustache"))
    end

    # Populate the rest of the config so each main section has a section template to render
    def set_section_templates
      settings = @config["settings"]
      default_template = settings["default_section_template"] || "raw.mustache"
      @config.each do |key, value|
        if key != "settings"
          value["section_template"] = default_template if value["section_template"].nil?
        end
      end
    end

    # Preload all of the templates and store them off a key
    def preload_templates
      find_templates()
      @templates.each do |key, value|
        @templates[key] = File.read(File.join(@layout_dir, value))
      end
    end

    # Finde templates within sections and manifests
    def find_templates
      @config.each do |name, item|
        item.each do |key, value|
          if key == "section_template"
            add_template(value)
          elsif key == "manifest"
            value.each do |prop|
              add_template(prop["template"]) if prop["template"]
            end
          end
        end
      end
    end

    # Add a template unless one already exists
    def add_template(name)
      key = name.gsub(/\./, "_")
      @templates[key] = name unless @templates[key]
    end

    # Render out each of the blocks to a section template and save as a layout
    def render_and_save
      render_primary_nav
      @blocks.each do |key, value|
        @base_dir = @config[key]["base_dir"]
        render key, value
        save_markup key
      end
    end

    def render_primary_nav
      @main_nav = ""
      @blocks.each do |key, value|
        @main_nav += "<li><a href='/#{key}.html'>#{key.capitalize}</a></li>"
      end
      @main_nav
    end

    def render(name, blocks)
      @html = ""
      @aside_nav = ""
      section = nil
      repo = @config["settings"]["repo"]

      blocks.each_with_index do |key, x|
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
          template_name = (@config[name]["manifest"][x]["template"] || @config[name]["section_template"]).gsub(/\./,"_")
          @html += Mustache.render(@templates[template_name], raw: raw, markup: markup, title: title, filepath: filepath, sherpas: sherpas, id: id, repo_url: repo_url)
        end
      end
    end

    def save_markup(key)
      title = @config["settings"]["title"]
      repo = @config["settings"]["repo"]
      layout = Mustache.render(@stache_layout, title: title, nav: @main_nav, aside: @aside_nav, layout: @html, repo: repo)
      File.open("#{@output_dir}#{key}.html", "w") do |file|
        file.write(layout)
      end
    end

  end
end

