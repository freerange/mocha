module CodeRay
  
  # = Duo
  #
  # $Id: scanner.rb 123 2006-03-21 14:46:34Z murphy $
  #
  # TODO: Doc.
  class Duo

    attr_accessor :scanner, :encoder

    def initialize lang, format, options = {}
      @scanner = CodeRay.scanner lang, CodeRay.get_scanner_options(options)
      @encoder = CodeRay.encoder format, options
    end

    class << self
      alias [] new
    end

    def encode code
      @scanner.string = code
      @encoder.encode_tokens(scanner.tokenize)
    end
    alias highlight encode

  end

end
