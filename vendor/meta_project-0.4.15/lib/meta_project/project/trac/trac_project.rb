module MetaProject
  module Project
    module Trac
      class TracProject < Base

        def initialize(trac_base_url, svn_root_url, svn_path)
          @trac_base_url = trac_base_url
          @svn_path = svn_path
          @scm = RSCM::Subversion.new("#{svn_root_url}#{svn_path}", svn_path)
          @tracker = ::MetaProject::Tracker::Trac::TracTracker.new(@trac_base_url)
        end
        
        TRAC_VERSION_PATTERN = /<strong>Trac ([\d\.]+)[^<]*<\/strong>/
        
        def scm_web
          unless @scm_web

            front_page = better_open(@trac_base_url).read
            if(front_page =~ TRAC_VERSION_PATTERN)
              version = $1
              # If there is no minor version part, add 0
              version = "#{version}.0" if version =~ /^[\d]+\.[\d]+$/              
              version = version.gsub(/\./, "").to_i
              if(version >= 90)
                html      = "#{@trac_base_url}/browser/#{@svn_path}/\#{path}?rev=\#{revision}"
                raw       = "#{@trac_base_url}/browser/#{@svn_path}/\#{path}?rev=\#{revision}&format=txt"
              else
                html      = "#{@trac_base_url}/file/#{@svn_path}/\#{path}?rev=\#{revision}"
                raw       = "#{@trac_base_url}/file/#{@svn_path}/\#{path}?rev=\#{revision}&format=txt"
              end

              dir                 = "#{@trac_base_url}/browser/#{@svn_path}/\#{path}"
              history             = "#{@trac_base_url}/log/#{@svn_path}/\#{path}"
              diff                = "#{@trac_base_url}/changeset/\#{revision}"
              child_dirs_pattern  = /title="Browse Directory" href="[^"]+">([^<]+)<\/a>/
              child_files_pattern = /title="View File" href="[^"]+">([^<]+)<\/a>/

              @scm_web = ScmWeb::Browser.new(dir, history, raw, html, diff, child_dirs_pattern, child_files_pattern)
            else
              raise ProjectException.new("Couldn't determine the Trac version. Is the URL '#{@trac_base_url}' correct? I was looking for the regexp /#{TRAC_VERSION_PATTERN.source}/ on the page, but couldn't find it.")
            end
          end

          @scm_web
        end
        
        def home_page
          "#{@trac_base_url}/wiki"
        end

      end
    end
  end
end