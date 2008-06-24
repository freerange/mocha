module Rake
  module XForge
    # This Rake task releases files to RubyForge and other GForge instaces
    # or SourceForge clones. In its most simple usage it looks like:
    #
    #   project = MetaProject::Project::XForge::RubyForge.new('xforge')
    #   # Create a new release of the xforge project on Rubyforge.
    #   task :release => [:gem] do
    #     Rake::XForge::Release.new(project) {}
    #   end
    #
    # The previous example will use defaults where it can. It will prompt
    # you for your xForge user name and password before it uploads all
    # gems under the pkg folder and creates a RubyForge release.
    #
    # While defaults are nice, you may want a little more control. You can
    # specify additional attributes:
    #
    # * #user_name
    # * #password
    # * #changes_file
    # * #version
    # * #files
    # * #release_name
    # * #release_notes
    # * #release_changes
    # * #package_name
    #
    # Example:
    #   project = MetaProject::Project::XForge::RubyForge.new('xforge')
    #   task :release => [:gem] do
    #     release_files = FileList[ 'pkg/*.gem', 'CHANGES' ]
    #
    #     Rake::XForge::Release.new(project) do |xf|
    #       # Never hardcode user name and password in the Rakefile!
    #       xf.user_name = ENV['RUBYFORGE_USER']
    #       xf.password = ENV['RUBYFORGE_PASSWORD']
    #       xf.files = release_files.to_a
    #       xf.release_name = "XForge 0.1"
    #   end
    #
    # This can be invoked from the command line:
    #
    #   rake release RUBYFORGE_USER=myuser \
    #                RUBYFORGE_PASSWORD=mypassword
    #
    # If you don't like blocks, you can do like this:
    #
    #   project = MetaProject::Project::XForge::RubyForge.new('xforge')
    #   task :release => [:gem] do
    #     xf = Rake::XForge::Release.new(project)
    #     ... # Set additional attributes
    #     xf.execute
    #   end
    class Release < Base
      # An array of files that should be uploaded to xForge. If this is not
      # provided, the Rake task will default to one of two values. If the
      # constant ::PKG_FILE_NAME is defined, then @files is
      # ["pkg/#{PKG_FILE_NAME}.gem"]. Otherwise, it is all .gem files under
      # the pkg directory.
      attr_accessor :files
      # The name of the release. If this is unset, MetaProject will try to
      # set it with the values of ::PKG_NAME and ::PKG_VERSION, #version, or
      # the project name.
      attr_accessor :release_name
      # Optional unless the CHANGES file is in a format different than
      # expected. You can set the release notes with this value.
      attr_accessor :release_notes
      # Optional unless the CHANGES file is in a format different than
      # expected. You can set the change notes with this value.
      attr_accessor :release_changes
      # Optional package name. This is *necessary* for projects that have
      # more than one released package. If not defined, then the *first*
      # package ID that is found on the xForge release page will be used.
      attr_accessor :package_name

      # Runs the release task.
      def execute
        raise "'release_name' not defined." unless @release_name
        raise "'files' not defined." unless @files
        raise "'release_notes' not defined." unless @release_notes
        raise "'release_changes' not defined." unless @release_changes
        session = @project.login(user_name, password)
        session.release(@release_name, @files, @release_notes,
                        @release_changes, @package_name)
      end

      protected
      def set_defaults
        unless @files
          if defined?(::PKG_FILE_NAME)
            @files = ["pkg/#{PKG_FILE_NAME}.gem"]
          else
            @files = Dir["pkg/**/*.gem"]
          end
        end

        unless @release_name
          if defined?(::PKG_NAME)
            if defined?(::PKG_VERSION)
              @release_name = "#{::PKG_NAME}-#{::PKG_VERSION}"
            elsif @version
              @release_name = "#{::PKG_NAME}-#{@version}"
            end
          else
            if defined?(::PKG_VERSION)
              @release_name = "#{@package.name}-#{::PKG_VERSION}"
            elsif @version
              @release_name = "#{@package.name}-#{@version}"
            end
          end
          unless @release_name
            raise "Cannot set release name. There is no version set."
          end
        end

        if @changes_file and @version
          begin
            vp = ::MetaProject::VersionParser.new
            version = vp.parse(@changes_file, @version)
            @release_notes = version.release_notes unless @release_notes
            unless @release_changes
              @release_changes = %Q[* #{version.release_changes.join("\n* ")}]
            end
          rescue => e
            STDERR.puts("Couldn't parse release info from #{@changes_file}")
            STDERR.puts(e.message)
            STDERR.puts(e.backtrace.join("\n"))
          end
        end
      end
    end
  end
end
