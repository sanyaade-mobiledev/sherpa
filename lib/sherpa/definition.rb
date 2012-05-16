module Sherpa
  class Definition
    attr_accessor :raw,
                  :markup,
                  :title,
                  :template,
                  :filepath,
                  :base_dir

    def initialize
      @raw = ''
    end

    def blocks
      @blocks ||= []
    end

    def subnav
      @subnav ||= []
    end

    def to_hash
      {
        :raw => raw,
        :markup => markup,
        :title => title,
        :template => template,
        :filepath => filepath,
        :base_dir => base_dir,
        :subnav => subnav,
        :blocks => blocks.map(&:to_hash)
      }
    end
  end
end
