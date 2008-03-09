module Mocha # :nodoc:
  
  # Configuration settings
  class Configuration
  
    class << self
    
      # :call-seq: allow(action)
      #
      # Allow the specified <tt>action</tt> (as a symbol).
      # The only <tt>action</tt> currently available is <tt>:stubbing_method_unnecessarily</tt>.
      def allow(action)
        configuration[action] = :allow
      end
    
      def allow?(action) # :nodoc:
        configuration[action] == :allow
      end
    
      # :call-seq: warn_when(action)
      #
      # Warn if the specified <tt>action</tt> (as a symbol) is attempted.
      # The only <tt>action</tt> currently available is <tt>:stubbing_method_unnecessarily</tt>.
      def warn_when(action)
        configuration[action] = :warn
      end
    
      def warn_when?(action) # :nodoc:
        configuration[action] == :warn
      end
    
      # :call-seq: prevent(action)
      #
      # Raise a StubbingError if the specified <tt>action</tt> (as a symbol) is attempted.
      # The only <tt>action</tt> currently available is <tt>:stubbing_method_unnecessarily</tt>.
      def prevent(action)
        configuration[action] = :prevent
      end
    
      def prevent?(action) # :nodoc:
        configuration[action] == :prevent
      end
    
      def reset_configuration # :nodoc:
        @configuration = nil
      end
    
      private
    
      def configuration # :nodoc:
        @configuration ||= {
          :stubbing_method_unnecessarily      => :allow
        }
      end
    
    end
    
  end
  
end