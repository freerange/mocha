# frozen_string_literal: true

class FakeLogger
  attr_reader :warnings

  def initialize
    @warnings = []
  end

  def warning(message)
    @warnings << message
  end
end
