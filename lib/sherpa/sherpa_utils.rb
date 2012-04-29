
module Sherpa
  class SherpaUtils

    # Determines if a comment block has a sherpa marker (//~)
    # TODO: Should accept a specific comment marker for a given file type (#~, /*~, /**~)
    def self.sherpa_block?(line)
      !!(line =~ /^\s*\/\/~/)
    end

    # Determines if a line is a continuation of a sherpa block
    def self.line_comment?(line)
      !!(line =~ /^\s*\/\//)
    end

    # Determines if a line is a `pre` block
    def self.pre_line?(line)
      !!(line =~ /^\s{4,}/)
    end

    # Tests to see if the line ends in ":"
    def self.header?(line)
      !!(line =~ /:\z/)
    end

    # Remove comment markers, sherpa identifier, and EOL whitespace
    def self.trim_comment_markers(line)
      cleaned = line.to_s.sub(/\s*\/\//, '').to_s.sub(/\s*~\s/, '')
      cleaned.rstrip
    end

    # Clean the left side of the comment block if the line ends with a line break
    def self.trim_left(line, content)
      cleaned = line
      if content[content.size - 1] == "\n"
        cleaned = cleaned.lstrip
      end
      cleaned
    end

    # Trim the header of markdown, tail colon, and downcase for use as a key
    def self.trim_header_for_key(line)
      cleaned = line.to_s.sub(/#+/, '').to_s.sub(/:/, '')
      cleaned.strip.downcase
    end

    # Return an `h3` markdown header unless it already starts in markdown format
    def self.add_markdown_header(line)
      line = "### #{line}\n" unless !!(line =~ /^#/)
      line
    end

    # Return the current filename and it's parent directory
    def self.pretty_path(base_path, filename)
      expression = Regexp.new(Regexp.escape(base_path.gsub(/^\./, "")))
      filename.gsub(/^\./, "").gsub(expression,"")
    end

    def self.get_section_name(path)
    end

    def self.filetype?(filename)
      File.extname(filename).gsub(/\./, "")
    end

  end
end

