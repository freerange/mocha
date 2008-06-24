module MetaProject
  module Project
    module Codehaus
      class CodehausProjectSvn < Base

        def initialize(unix_name, svn_path, jira_id)
          @unix_name = unix_name
          @name = unix_name
          @scm = RSCM::Subversion.new("svn://svn.#{unix_name}.codehaus.org/#{unix_name}/scm/#{svn_path}", svn_path)
          @tracker = ::MetaProject::Tracker::Jira::JiraTracker.new("http://jira.codehaus.org", jira_id)

          dir       = "http://svn.#{unix_name}.codehaus.org/#{svn_path}/\#{path}"
          history   = dir
          raw       = "#{history}?rev=\#{revision}"
          html      = "#{raw}&view=markup"
          # http://svn.picocontainer.codehaus.org/java/picocontainer/trunk/container/project.xml?r1=2220&r2=2234&p1=java/picocontainer/trunk/container/project.xml&p2=java/picocontainer/trunk/container/project.xml
          diff      = "#{history}?r1=\#{previous_revision}&r2=\#{revision}&p1=#{svn_path}/\#{path}&p2=#{svn_path}/\#{path}"
          child_dirs_pattern = /<a name="([^"]+)" href="([^"]+)">[\r\n\s]+<img src="\/icons\/small\/dir.gif"/
          child_files_pattern = /<a href="[^"]+\/([^\?]+)\?rev=([\d]+)&view=auto">/

          @scm_web = ScmWeb::Browser.new(dir, history, raw, html, diff, child_dirs_pattern, child_files_pattern)
        end

        def home_page
          "http://#{@unix_name}.codehaus.org/"
        end

      end
    end
  end
end