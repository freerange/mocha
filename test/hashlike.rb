require 'forwardable'

class Hashlike
  extend Forwardable

  def_delegators :@hash, :keys, :[]

  def initialize(hash = {})
    @hash = hash
  end
end
