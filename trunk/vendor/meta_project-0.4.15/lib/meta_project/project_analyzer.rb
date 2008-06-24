module MetaProject
  module ProjectAnalyzer
    # Creates a project from an scm web url. The project has a +tracker+, +scm+ and +scm_web+.
    def project_from_scm_web(url, options=nil)
      # RubyForge
      if(url =~ /http:\/\/rubyforge.org\/cgi-bin\/viewcvs.cgi\/(.*)[\/]?\?cvsroot=(.*)/)
        unix_name = $2
        mod = $1[-1..-1] == "/" ? $1[0..-2] : $1
        return Project::XForge::RubyForge.new(unix_name, mod)
      end

      # SourceForge
      if(url =~ /http:\/\/cvs.sourceforge.net\/viewcvs.py\/([^\/]*)\/(.*)/)
        unix_name = $1
        mod = $2[-1..-1] == "/" ? $2[0..-2] : $2
        return Project::XForge::SourceForge.new(unix_name, mod)
      end

      # Trac
      if(url =~ /(http:\/\/.*)\/browser\/(.*)/)
        trac_base_url = $1
        svn_path = $2[-1..-1] == "/" ? $2[0..-2] : $2
        return Project::Trac::TracProject.new(trac_base_url, options[:trac_svn_root_url], svn_path)
      end
      
      # Codehaus SVN
      if(url =~ /http:\/\/svn.(.*).codehaus.org\/(.*)/)
        unix_name = $1
        svn_path = $2[-1..-1] == "/" ? $2[0..-2] : $2
        return Project::Codehaus::CodehausProjectSvn.new(unix_name, svn_path, options[:jira_project_id])
      end

    end
    
  end
end