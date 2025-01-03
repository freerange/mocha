# frozen_string_literal: true

require 'mocha/deprecation'

module DeprecationCapture
  attr_reader :deprecation_warnings

  def capture_deprecation_warnings
    @deprecation_warnings = []
    original_logger = Mocha::Deprecation.logger
    Mocha::Deprecation.logger = proc do |message|
      @deprecation_warnings << message
    end
    begin
      yield
    ensure
      Mocha::Deprecation.logger = original_logger
    end
    @deprecation_warnings
  end

  def last_deprecation_warning
    deprecation_warnings.last
  end
end
