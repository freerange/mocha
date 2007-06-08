module MetaProject
  module Tracker
    module XForge
      class SourceForgeTracker < XForgeTracker
        
        def subtracker_pattern
          /\/tracker\/\?atid=(\d+)&amp;group_id=\d*&amp;func=browse/
        end

        def issue_summary_pattern(identifier)
          /<a href=\"\/tracker\/index.php\?func=detail&amp;aid=#{identifier}&amp;group_id=\d+&amp;atid=\d+\">([^<]*)<\/a>/
        end

      end
    end
  end
end
