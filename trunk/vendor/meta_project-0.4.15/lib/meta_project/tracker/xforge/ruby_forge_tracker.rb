module MetaProject
  module Tracker
    module XForge
      class RubyForgeTracker < XForgeTracker

        def subtracker_pattern
          /\/tracker\/\?atid=(\d+)&group_id=\d*&func=browse/
        end

        def issue_summary_pattern(identifier)
          /<a href=\"\/tracker\/index.php\?func=detail&aid=#{identifier}&group_id=\d+&atid=\d+\">([^<]*)<\/a>/
        end

      end
    end
  end
end
