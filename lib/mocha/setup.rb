require 'mocha/version'
require 'mocha/integration'

module Mocha
  module Setup
  end

  def self.activate
    Integration.activate
  end
end

Mocha.activate
