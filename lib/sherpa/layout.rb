
require 'mustache'

module Sherpa
  class Layout

    attr_accessor :config, :output_dir, :layout_dir, :stache_layout, :templates

    def initialize(config, blocks)
      @config = config
      @blocks = JSON.parse blocks
      @templates = {}
      set_defaults()
      configure_section_templates()
      cache_templates()
    end

    # Set default global properties from the settings item
    def set_defaults
      settings = @config["settings"]
      @base_dir = ""
      @output_dir = settings["output_dir"] || "./"
      @layout_dir = settings["layout_dir"] || "./lib/layouts/"
      @stache_layout = File.read(File.join(@layout_dir, settings["layout_template"] || "layout.mustache"))
    end

    # Populate the rest of the config so each main section has a section template to render
    def configure_section_templates
      settings = @config["settings"]
      default_template = settings["default_section_template"] || "raw.mustache"
      @config.each do |key, value|
        if key != "settings"
          value["section_template"] = default_template if value["section_template"].nil?
        end
      end
    end

    # Preload all of the templates and store them off a key
    def cache_templates
      find_templates()
      @templates.each do |key, value|
        @templates[key] = File.read(File.join(@layout_dir, value))
      end
    end

    # Find templates within sections and manifests
    def find_templates
      @config.each do |name, item|
        item.each do |key, value|
          if key == "section_template"
            add_template(value)
          elsif key == "manifest"
            if value.is_a? String
              value = add_globs(value, item["base_dir"])
              item["manifest"] = value
            end
            value.each do |prop|
              add_template(prop["template"]) if prop["template"]
            end
          end
        end
      end
    end

    def add_globs(manifest, base)
      files = []
      globbed = Dir["#{base}/**/*#{manifest}"]
      globbed.each do |f|
        files.push f
      end
      files
    end

    # Add a template unless one already exists
    def add_template(name)
      key = name.gsub(/\./, "_")
      @templates[key] = name unless @templates[key]
    end

    # Get the template from the list for the current section
    def get_section_template(key, index)
      (@config[key]["manifest"][index]["template"] || @config[key]["section_template"]).gsub(/\./,"_")
    end

    # Render out each of the blocks to a section template and save as a layout
    def render_and_save
      primary = render_primary_nav
      @blocks.each do |key, value|
        @base_dir = @config[key]["base_dir"]
        page = render_page key, value
        save_page key, primary, page[:aside], page[:html]
      end
    end

    # Renders the primary navigation for all pages
    def render_primary_nav
      main_nav = ""
      @blocks.each do |key, value|
        main_nav += "<li><a href='/#{key}.html'>#{key.capitalize}</a></li>"
      end
      main_nav
    end

    # Renders a given page with an aside navigation
    def render_page(key, value)
      html = ""
      aside = ""
      section = nil
      repo = @config["settings"]["repo"]

      value.each_with_index do |blocks, index|
        blocks.each do |name, block|

          # Setup some shared values
          subnav = block["subnav"]
          repo_url = "#{repo}#{block["filepath"].gsub(/^\./, 'blob/master')}"
          filepath = Utils.pretty_path(@base_dir, block["filepath"])
          id = Utils.uid(filepath).gsub(/_/, '-')

          # Build the aside navigation and headers
          cur_section = !!(filepath =~ /\//) ? filepath.split('/')[0] : "root"
          if cur_section != section
            section = cur_section
            aside += "<li class='sherpa-nav-header'>#{section.capitalize}</li>"
          end
          aside += "<li><a href='##{id}'>#{block["title"]}</a></li>"

          # If an aside navigation has a sub navigation add it
          if !subnav.empty?
            subnav.each_with_index do |item, n|
              link_id = "#{id}-#{item}"
              aside += "<li class='sherpa-subnav'><a href='##{link_id}'>#{item}</a></li>"
              block["sherpas"][n + 1][:id] = "#{link_id}"
            end
          end

          # Save the html
          template = get_section_template(key, index)
          html += Mustache.render(@templates[template], block: block, repo_url: repo_url, filepath: filepath, id: id)
        end
      end
      {aside: aside, html: html}
    end

    def save_page(key, primary_nav, aside_nav, html)
      title = @config["settings"]["title"]
      repo = @config["settings"]["repo"]
      layout = Mustache.render(@stache_layout, title: title, nav: primary_nav, aside: aside_nav, layout: html, repo: repo)
      File.open("#{@output_dir}#{key}.html", "w") do |file|
        file.write(layout)
      end
    end

  end
end

