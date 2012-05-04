
#~
# ## Utils
# Static class of utility methods for the parser and layout classes
#
# Method                 |Params                  |Description
# -----------------------|------------------------|----------------------------------------------------------------------------
# `sherpa_block?`        |`line`                  |Determines if a comment block has a sherpa marker `#~`
# `line_comment?`        |`line`                  |Determines if a line is a continuation of a sherpa block
# `pre_line?`            |`line`                  |Determines if a line is a `pre` block
# `sherpa_section?`      |`line`                  |Tests to see if the line ends in `:`
# `trim_comment_markers` |`line`                  |Remove comment markers, sherpa identifier, and EOL whitespace
# `trim_left`            |`line`, `content`       |Clean the left side of the comment block if the line ends with a line break
# `add_markdown_header`  |`line`                  |Return an `h3` markdown header unless it already starts in markdown format
# `pretty_path`          |`base_path`, `filename` |Return the current filename and it's parent directory
# `filetype?`            |`filename`              |Retrieves the extension name from file less the dot
#
# Notes:
# - **Note!** Headers should also be able to be denoted as just markdown

module Sherpa
  class Utils

    def self.sherpa_block?(line)
      !!(line =~ /^\s*\/\/~|^\s*#~/)
    end

    def self.line_comment?(line)
      !!(line =~ /^\s*\/\/|^\s*#/)
    end

    def self.pre_line?(line)
      !!(line =~ /^\s{4,}/)
    end

    def self.markdown_header?(line)
      !!(line =~ /^\s*#/)
    end

    def self.sherpa_section?(line)
      !!(line =~ /:\z/)
    end

    def self.trim_comment_markers(line)
      cleaned = line.gsub(/^\s*/, '').gsub(/\s*\/\/|\s*^#/, '').gsub(/\s*~\s/, '')
      cleaned.rstrip
    end

    def self.trim_left(line, content)
      cleaned = line
      if content[content.size - 1] == "\n"
        cleaned = cleaned.lstrip
      end
      cleaned
    end

    def self.trim_sherpa_section_for_key(line)
      cleaned = line.gsub(/#+/, '').gsub(/:/, '').strip.gsub(/\s/,'_')
      cleaned.strip.downcase
    end

    def self.trim_for_title(line)
      line.gsub(/#+/, '').gsub(/:/, '').gsub(/`/, '').strip
    end

    def self.trim_colon(line)
      line.gsub(/:/, '').strip
    end

    def self.uid(file)
      file.gsub(/^\./, '').gsub(/^\//, '').gsub(/\//, '_').split('.')[0]
    end

    def self.add_markdown_header(line)
      line = "#### #{line}\n" unless !!(line =~ /^#/)
      line
    end

    def self.pretty_path(base_path, filename)
      expression = Regexp.new(Regexp.escape(base_path.gsub(/^\./, "")))
      filename.gsub(/^\./, "").gsub(expression,"")
    end

    def self.filetype?(filename)
      File.extname(filename).gsub(/\./, "")
    end

    def self.is_markdown_file?(filename)
      file = File.extname(filename).gsub(/\./, "")
      !!(file =~ /md|mkdn?|mdown|markdown/)
    end

  end
end

