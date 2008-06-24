module MetaProject
  module Tracker
    module Trac
      class TracTracker < Base
        include DigitIssues

        attr_accessor :trac_base_url

        def initialize(trac_base_url=nil)
          @trac_base_url = trac_base_url
        end
        
        def overview
          "#{@trac_base_url}/report"
        end
        
        def materialize(issue)
          begin
            url = "#{@trac_base_url}/ticket/#{issue.identifier}"
            html = better_open(url).read
            summary = html[/Ticket ##{issue.identifier}\s*<\/h1>\s*<h2>([^<]*)<\/h2>/n, 1]
            issue.attributes[:summary] = summary
            issue.attributes[:url] = url
          rescue OpenURI::HTTPError => e
            STDERR.puts e.message
          end
          issue
        end
        
      end
    end
  end
end