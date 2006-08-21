module Test
  module Unit
    module Util
      module BacktraceFilter
        
        # quick rip-off of Test::Unit code - there must be a better way of doing this!
        
        MOCHA_FILE_SEPARATORS = %r{[\\/:]}
        MOCHA_PREFIX = __FILE__.split(MOCHA_FILE_SEPARATORS)[0..-3]
        MOCHA_RB_FILE = /\.rb\Z/
        
        alias_method :__filter_backtrace__, :filter_backtrace
        
        def filter_backtrace(backtrace, prefix=nil)
          backtrace = __filter_backtrace__(backtrace, prefix)
          return ["No backtrace"] unless(backtrace)
          split_p = if(prefix)
            prefix.split(MOCHA_FILE_SEPARATORS)
          else
            MOCHA_PREFIX
          end
          match = proc do |e|
            split_e = e.split(MOCHA_FILE_SEPARATORS)[0, split_p.size]
            next false unless(split_e[0..-2] == split_p[0..-2])
            split_e[-1].sub(MOCHA_RB_FILE, '') == split_p[-1]
          end
          return backtrace unless(backtrace.detect(&match))
          found_prefix = false
          new_backtrace = backtrace.reverse.reject do |e|
            if(match[e])
              found_prefix = true
              true
            elsif(found_prefix)
              false
            else
              true
            end
          end.reverse
          new_backtrace = (new_backtrace.empty? ? backtrace : new_backtrace)
          new_backtrace = new_backtrace.reject(&match)
          new_backtrace.empty? ? backtrace : new_backtrace
        end
      end
    end
  end
end
