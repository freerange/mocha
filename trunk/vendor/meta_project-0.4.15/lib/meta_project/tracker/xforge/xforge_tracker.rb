
require 'meta_project/tracker/base'
require 'meta_project/tracker/digit_issues'
require 'meta_project/tracker/issue'

module MetaProject
  module Tracker
    module XForge
      class XForgeTracker < Base
        include DigitIssues

        attr_accessor :overview, :project

        # TODO: don't pass in project!! pass in hostname and id! This won't work from DC!!
        def initialize(overview=nil, project=nil)
          @overview, @project = overview, project
        end

        # Finds an Issue by +identifier+
        def issue(identifier)
          sub_trackers.each do |sub_tracker|
            issue = sub_tracker.issue(identifier)
            return issue unless issue.nil?
          end
          nil
        end
        
        def materialize(issue)
          issue
        end
        
        def create(issue, user_name, password)
          # TODO: get the subtracker atid or name from the issue's options
          subtracker = sub_trackers[0]
          subtracker.create(issue, user_name, password)
        end
        
        class SubTracker
          include HTTP::Multipart
          
          # Issue modification constants
          OPEN = 1
          CLOSED = 2
          DELETED = 3

          def initialize(tracker, atid)
            @tracker = tracker
            @atid = atid
            # FIXME: This will only show open items.
            @baseurl = "#{tracker.overview}&atid=#{atid}"
            @overview = "#{@baseurl}&func=browse"
          end

          def issue(identifier)
            html = better_open(@overview).read

            issue_summary_pattern = @tracker.issue_summary_pattern(identifier)
            if(html =~ issue_summary_pattern)
              issue_url = @tracker.project.group_id_uri("tracker/index.php", "&atid=#{@atid}&func=detail&aid=#{identifier}")
              issue_summary = $1.strip
              return Issue.new(self, :identifier => identifier,:summary => issue_summary, :url => issue_url)
            else
              nil
            end
          end
          
          def create(issue, user_name, password)
            session = @tracker.project.login(user_name, password)
            
            Net::HTTP.start(@tracker.project.host, 80) do |http|
              query_hash = {
                "func" => "postadd",
                "category_id" => "100", # seems to be standard for all trackers
                "artifact_group_id" => "100", # seems to be standard for all trackers
                "summary" => issue.summary,
                "details" => issue.detail,
                "user_email" => "",
              }

              target = "/news/submit.php" #TODO: use this?
              response = post_multipart(http, @baseurl, query_hash, session.request_headers)
              
              # the post brings us back to the overview page, where the new issue is the last one
              response.body.scan(/aid=([\d]+)/) do |a|
                issue.attributes[:identifier] = a[0]
              end
            end
            issue
          end

          def close(issue, user_name, password)
            modify(issue, user_name, password, CLOSED)
          end

          def delete(issue, user_name, password)
            modify(issue, user_name, password, DELETE)
          end

        private

          def modify(issue, user_name, password, status)
            session = @tracker.project.login(user_name, password)
            
            Net::HTTP.start(@tracker.project.host, 80) do |http|
              query_hash = {
                "group_id" => @tracker.project.group_id,
                "atid" => @atid,
                "func" => "postmod",
                "$result[]" => "",
                "artifact_id" => issue.identifier,
                "new_artifact_type_id" => @atid,
                "category_id" => "100", # None
                "artifact_group_id" => "100", # None
                "assigned_to" => "100", # None
                "priority" => "3", # None
                "status_id" => status,
                "resolution_id" => "100",
                "canned_respnse" => "100",
                "summary" => issue.summary,
                "details" => issue.detail
              }

              target = "/tracker/index.php"
              response = post_multipart(http, target, query_hash, session.request_headers)

              close_pattern = /Updated successfully/
              unless(response.body =~ close_pattern)
                File.open("xforge_close.html", "w") {|io| io.write response.body}
                STDERR.puts "WARNING: Failed to close issue \##{issue.identifier}. I was looking for /#{close_pattern.source}/. Response written to xforge_close.html"
              end
            end
            issue
          end
        end

      private
      
        def sub_trackers
          @sub_trackers ||= atids.collect {|atid| SubTracker.new(self, atid)}
        end

        # The ids of the subtrackers
        def atids
#          headers = {
#            "User-Agent" => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.7.8) Gecko/20050511 Firefox/1.0.4",
#            "Accept" => "text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5",
#            "Accept-Language" => "en-us,en;q=0.5",
#            "Accept-Encoding" => "gzip,deflate",
#            "Accept-Charset" => "ISO-8859-1,utf-8;q=0.7,*;q=0.7",
#            "Keep-Alive" => "300",
#            "Connection" => "close",
#            "X-Requested-With" => "XMLHttpRequest",
#            "X-Prototype-Version" => "1.3.1",
#            "Content-Type" => "application/x-www-form-urlencoded",
#            "Content-Length" => "0",
#            "Cookie" => "author=AnonymousCoward; _session_id=975a583d513190522ce3aeba315552d0",
#            "Pragma" => "no-cache",
#            "Cache-Control" => "no-cache"
#          }
          
          html = better_open(overview).read
          STDERR.puts "The HTML returned from #{overview} was empty! This might be because the server is trying to fool us" if html == ""

          # TODO: there has to be a better way to extract the atids from the HTML!
          atids = []
          offset = 0
          look_for_atid = true
          while(look_for_atid)
            match_data = subtracker_pattern.match(html[offset..-1])
            if(match_data)
              offset += match_data.begin(1)
              atids << match_data[1]
            else
              look_for_atid = false
            end
          end
          if atids.empty?
            debug_file = "xforge_tracker_debug.html"
            File.open(debug_file, "w"){|io| io.write html}
            STDERR.puts "WARNING: No subtrackers found at #{overview}."
            STDERR.puts "I was looking for /#{subtracker_pattern.source}/"
            STDERR.puts "Please consider filing a bug report at http://rubyforge.org/tracker/?atid=3161&group_id=801&func=browse"
            STDERR.puts "The HTML has been saved to #{debug_file}"
          end
          atids
        end

      end
    end
  end
end