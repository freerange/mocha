module MetaProject
  module Project
    module XForge
      class RubyForge < XForgeBase

        def initialize(unix_name, cvs_mod=nil)
          super("rubyforge.org", unix_name, cvs_mod)
        end

        def tracker_class
          ::MetaProject::Tracker::XForge::RubyForgeTracker
        end

      protected

        def create_cvs(unix_name, mod)
          RSCM::Cvs.new(":pserver:anonymous@rubyforge.org:/var/cvs/#{unix_name}", mod)
        end

        def create_view_cvs(unix_name, mod)
          view_cvs = "http://rubyforge.org/cgi-bin/viewcvs.cgi/"
          cvsroot = "?cvsroot=#{unix_name}"
          path_cvs_root = "#{mod}/\#{path}#{cvsroot}"
          path_cvs_root_rev = "#{path_cvs_root}&rev=\#{revision}"

          dir      = "#{view_cvs}#{path_cvs_root}"
          history  = "#{view_cvs}#{path_cvs_root}"
          raw      = "#{view_cvs}*checkout*/#{path_cvs_root_rev}"
          html     = "#{view_cvs}#{path_cvs_root_rev}&content-type=text/vnd.viewcvs-markup"
          diff     = "#{view_cvs}#{mod}/\#{path}.diff#{cvsroot}&r1=\#{previous_revision}&r2=\#{revision}"

          child_dirs_pattern = /href="([^\?]*)\/\?cvsroot=#{unix_name}">/
          child_files_pattern = /href="([^\?^\/]*)\?cvsroot=#{unix_name}">/

          ScmWeb::Browser.new(dir, history, raw, html, diff, child_dirs_pattern, child_files_pattern)
        end
        
        # Regexp used to find projects' home page
        def home_page_regexp
          # This seems a little volatile
          /<a href=\"(\w*:\/\/[^\"]*)\"><img src=\"\/themes\/osx\/images\/ic\/home/
        end        

      end
    end
  end
end