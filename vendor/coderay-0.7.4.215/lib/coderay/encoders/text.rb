module CodeRay
module Encoders

  class Text < Encoder

    include Streamable
    register_for :text

    FILE_EXTENSION = 'txt'

    DEFAULT_OPTIONS = {
      :separator => ''
    }

  protected
    def setup options
      super
      @sep = options[:separator]
    end

    def token text, kind
      return unless text.respond_to? :to_str
      @out << text + @sep
    end

    def finish options
      @out.chomp @sep
    end

  end

end
end
