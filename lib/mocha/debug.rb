module Mocha
  module Debug
    OPTIONS = (ENV['MOCHA_OPTIONS'] || '').split(',').each_with_object({}) do |key, hash|
      hash[key] = true
    end.freeze

    def self.puts(message)
      warn(message) if OPTIONS['debug']
    end
  end
end
