
#~
# Static class of utility methods for the parser and layout classes
#
# Method                          |Params                  |Description
# --------------------------------|------------------------|----------------------------------------------------------------------------
# `sherpa_block?`                 |`line`                  |Determines if a comment block has a sherpa marker `#~`
# `line_comment?`                 |`line`                  |Determines if a line is a continuation of a sherpa block
# `multi_comment_start?`          |`line`                  |Determines if a line is the beginning of a multi line comment block: `/*`
# `multi_comment_end?`            |`line`                  |Determines if a line is the end of a multi line comment block: `*/`
# `pre_line?`                     |`line`                  |Determines if a line is a `pre` block
# `sherpa_section?`               |`line`                  |Tests to see if the line ends in `:`
# `markdown_header?`              |`line`                  |Tests to see if the line ends starts with a markdown header
# `is_markdown_file?`             |`line`                  |Tests to see if the file is markdown
# `lorem?`                        |`line`                  |Tests to see if the current line contains a sherpa `lorem xsmall small medium alt` tag
# `lorem_type`                    |`line`                  |Returns the type of sherpa `lorem` tag being used
# `generate_lorem`                |`line`                  |Generates a lorem ipsum block based on the type of sherpa `lorem` tag in use
# `trim_comment_markers`          |`line`                  |Remove comment markers, sherpa identifier, and EOL whitespace
# `trim_left`                     |`line`, `content`       |Clean the left side of the comment block if the line ends with a line break
# `trim_for_title`                |`line`                  |Trim out markdown headers for a plain text title
# `trim_colon`                    |`line`                  |Trim out the trailing colon `:`
# `trim_sherpa_section_for_key`   |`line`                  |Turn a sherpa section into a readable key
# `uid`                           |`file`                  |Generate a unique ID for use in keys and anchor tags from a filepath
# `add_markdown_header`           |`line`                  |Turns a sherpa section into a markdown `h4` unless the line is already a markdown header
# `pretty_path`                   |`base_path`, `filename` |Return the current filename and it's parent directory
#

module Sherpa
  class Utils

    @lorem = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    @lorem_alt = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt."
    @lorem_medium = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation."
    @lorem_small = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt."
    @lorem_xsmall = "Lorem ipsum dolor sit amet."

    def self.sherpa_block?(line)
      !!(line =~ /^\s*\/\/~|^\s*#~|^\s*\/\**~/)
    end

    def self.line_comment?(line)
      !!(line =~ /^\s*\/\/|^\s*#|^\s*\*/)
    end

    def self.multi_comment_start?(line)
      !!(line =~ /^\s*\/\*/)
    end

    def self.multi_comment_end?(line)
      !!(line =~ /.*\*\//)
    end

    def self.pre_line?(line)
      !!(line =~ /^\s{4,}/)
    end

    def self.sherpa_section?(line)
      !!(line =~ /:\z/)
    end

    def self.markdown_header?(line)
      !!(line =~ /^\s*#/)
    end

    def self.is_markdown_file?(filename)
      file = File.extname(filename).gsub(/\./, "")
      !!(file =~ /md|mkdn?|mdown|markdown/)
    end

    def self.lorem?(line)
      !!(line =~ /~lorem/)
    end

    def self.lorem_type(line)
      line.match(/~lorem_xsmall|~lorem_small|~lorem_medium|~lorem_alt|~lorem/).to_s
    end

    def self.generate_lorem(line)
      type = lorem_type(line)
      if type == "~lorem_xsmall"
        line = line.gsub(/#{type}/, @lorem_xsmall)
      elsif type == "~lorem_small"
        line = line.gsub(/#{type}/, @lorem_small)
      elsif type == "~lorem_medium"
        line = line.gsub(/#{type}/, @lorem_medium)
      elsif type == "~lorem_alt"
        line = line.gsub(/#{type}/, @lorem_alt)
      elsif type == "~lorem"
        line = line.gsub(/#{type}/, @lorem)
      end
      line
    end

    # Trim indentation, then comment markers, then sherpa marker
    def self.trim_comment_markers(line)
      # cleaned = line.sub(/^\s*/, '')
      cleaned = line.sub(/^\s*\/+/, '')
      cleaned = cleaned.sub(/^\s*#/, '')
      cleaned = cleaned.sub(/^\s*\*+/, '')
      cleaned = cleaned.sub(/^\s*\/+/, '')
      cleaned = cleaned.sub(/^\s*~/, '')
      cleaned.rstrip
    end

    def self.trim_left(line, content)
      cleaned = line
      if content[content.size - 1] == "\n"
        cleaned = cleaned.lstrip
      end
      cleaned
    end

    def self.trim_for_title(line)
      line.gsub(/#+/, '').gsub(/:/, '').gsub(/`/, '').strip
    end

    def self.trim_colon(line)
      line.gsub(/:/, '').strip
    end

    def self.trim_sherpa_section_for_key(line)
      cleaned = line.gsub(/#+/, '').gsub(/:/, '').strip.gsub(/\s/,'_')
      cleaned.strip.downcase
    end

    def self.add_markdown_header(line)
      line = "#### #{line}\n" unless !!(line =~ /^#/)
      line
    end

    def self.pretty_path(base_path, filename)
      expression = Regexp.new(Regexp.escape(base_path.gsub(/^\./, "")))
      filename.gsub(/^\./, "").gsub(expression,"")
    end

    def self.uid(file)
      file.gsub(/^\./, '').gsub(/^\//, '').gsub(/\//, '_').split('.')[0]
    end

  end
end

