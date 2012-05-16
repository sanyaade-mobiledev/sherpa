module Sherpa
  class Block
    attr_accessor :title

    def initialize(attrs={})
      attrs.each do |attr, val|
        setter = "#{attr}=".to_sym
        public_send(setter, val) if respond_to?(setter)
      end
    end

    def sections
      @sections ||= {}
    end

    def [](key)
      sections[key]
    end

    def []=(key, val)
      val = tidy(val) if key == :usage_showcase
      sections[key] = val
    end

    def to_hash
      sections.merge({'title' => title})
    end

    protected
    def tidy(val)
      val.gsub(/^\n/, "")
    end
  end
end
