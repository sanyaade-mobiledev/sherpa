
require 'mustache'

#~
# Layout
module Sherpa
  class Layout

    attr_accessor :config,
                  :output_dir,
                  :layout_dir,
                  :stache_layout,
                  :templates

    def initialize(config)
      @config = config
      @templates = {}
      set_defaults()
      cache_templates()
    end

    # Set default global properties from the settings item
    def set_defaults
      settings = @config[:settings]
      @output_dir = settings["output_dir"] || "./sherpa"
      @layout_dir = settings["layout_dir"] || "./lib/layouts/"
      @stache_layout = File.read(File.join(@layout_dir, settings["layout_template"] || "layout.mustache"))
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
      @config.each do |name, section|
        unless name.to_s == "settings"
          section.each do |file|
            file.each do |item, value|
              add_template value if item.to_s == 'template'
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

    def render_and_save
      primary = render_primary_nav
      @config.each do |key, section|
        unless key.to_s == "settings"
          page = render_page key, section
          save_page key, primary, page[:aside], page[:html]
        end
      end
    end

    # Renders the primary navigation for all pages
    def render_primary_nav
      main_nav = ""
      @config.each do |key, value|
        unless key.to_s == "settings"
          path = @output_dir.sub(/^\./,"")
          main_nav += "<li><a href='#{path}#{key}.html'>#{key.capitalize}</a></li>"
        end
      end
      main_nav
    end

    def get_section_path(filepath, basedir)
      !!(filepath =~ /\//) ? filepath.split('/')[0] : basedir.split('/').last
    end

    def render_page(key, file_definitions)
      html = ""
      aside = ""
      section = nil
      repo = @config[:settings]["repo"]

      file_definitions.each do |file_def|
        # Setup some shared values
        subnav = file_def[:subnav]
        repo_url = "#{repo}#{file_def[:filepath].gsub(/^\./, 'blob/master')}"
        filepath = Utils.pretty_path(file_def[:base_dir], file_def[:filepath])
        id = Utils.uid(filepath).gsub(/_/, '-')
        template = file_def[:template].gsub(/\./,"_")

        # Build the aside navigation and headers
        cur_section = get_section_path(filepath, file_def[:base_dir])
        if cur_section != section
          section = cur_section
          aside += "<li class='sherpa-nav-header'>#{section.capitalize}</li>"
        end
        aside += "<li><a href='##{id}'>#{file_def[:title]}</a></li>"

        # If an aside navigation has a sub navigation add it
        if !subnav.empty?
          subnav.each_with_index do |item, n|
            link_id = "#{id}-#{item}"
            aside += "<li class='sherpa-subnav'><a href='##{link_id}'>#{item}</a></li>"
            # skip first block because it is a file summary so always add one to blocks to get the right block that matches the subnav
            file_def[:blocks][n + 1][:id] = "#{link_id}"
          end
        end

        html += Mustache.render(@templates[template], file: file_def, repo_url: repo_url, filepath: filepath, id: id)
      end
      {aside: aside, html: html}
    end

    def save_page(key, primary_nav, aside_nav, html)
      title = @config[:settings]["title"]
      repo = @config[:settings]["repo"]
      layout = Mustache.render(@stache_layout, title: title, nav: primary_nav, aside: aside_nav, layout: html, repo: repo, page: key)
      File.open("#{@output_dir}#{key}.html", "w") do |file|
        file.write(layout)
      end
    end

  end
end

