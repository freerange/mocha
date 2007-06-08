require 'meta_project/tracker/xforge'

module MetaProject
  module Project
    module XForge
      class SourceForge < XForgeBase

        def initialize(unix_name, cvs_mod=nil)
          super("sourceforge.net", unix_name, cvs_mod)
        end

        def tracker_class
          ::MetaProject::Tracker::XForge::SourceForgeTracker
        end

      protected

        def create_cvs(unix_name, mod)
          RSCM::Cvs.new(":pserver:anonymous@cvs.sourceforge.net:/cvsroot/#{unix_name}", mod)
        end

        def create_view_cvs(unix_name, mod)
          view_cvs = "http://cvs.sourceforge.net/viewcvs.py/"
          unix_name_mod = "#{unix_name}/#{mod}"
          project_path = "#{unix_name_mod}/\#{path}"
          rev = "rev=\#{revision}"

          dir      = "#{view_cvs}#{project_path}"
          history  = "#{view_cvs}#{project_path}"
          raw      = "#{view_cvs}*checkout*/#{project_path}?#{rev}"
          html     = "#{history}?#{rev}&view=markup"
          diff     = "#{history}?r1=\#{previous_revision}&r2=\#{revision}"


          child_dirs_pattern = /<img src="\/icons\/small\/dir.gif"\s+alt="\(dir\)"\s+border=0\s+width=16\s+height=16>[\r\n\s]*([^\/]+)\/<\/a>/
          child_files_pattern = /href="[^\?]+\/([^\?]+)\?rev=([^&]+)&view=log">/

          ScmWeb::Browser.new(dir, history, raw, html, diff, child_dirs_pattern, child_files_pattern)
        end

        # Regexp used to find projects' home page
        def home_page_regexp
          # This seems a little volatile
          /<A href=\"(\w*:\/\/[^\"]*)\">&nbsp;Project Home Page<\/A>/
        end

      end
    end
  end
end