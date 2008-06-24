module Rake
  module XForge
    # This Rake task publishes news entries for a project. Publishing news
    # is a good way to make your project visible on the main RubyForge page.
    #
    #   project = MetaProject::Project::XForge::RubyForge.new('xforge')
    #   # Create a new news item for the xforge project on Rubyforge.
    #   task :news => [:gem] do
    #     Rake::XForge::NewsPublisher.new(project) {}
    #   end
    #
    # The previous example will use defaults where it can. It will prompt
    # you for your xForge user name and password before it posts a news item
    # about the project with a default subject and news details.
    #
    # While defaults are nice, you may want a little more control. You can
    # specify additional attributes:
    #
    # * #user_name
    # * #password
    # * #changes_file
    # * #version
    # * #subject
    # * #details
    #
    # Example:
    #   project = MetaProject::Project::XForge::RubyForge.new('xforge')
    #   task :news => [:gem] do
    #     Rake::XForge::NewsPublisher.new(project) do |xf|
    #       # Never hardcode user name and password in the Rakefile!
    #       xf.user_name = ENV['RUBYFORGE_USER']
    #       xf.password = ENV['RUBYFORGE_PASSWORD']
    #       xf.subject = "XForge 0.1 Released"
    #       xf.details = "Today, XForge 0.1 was released to the ..."
    #     end
    #   end
    #
    # This can be invoked from the command line:
    #
    #   rake news RUBYFORGE_USER=myuser \
    #             RUBYFORGE_PASSWORD=mypassword
    #
    # If you don't like blocks, you can do like this:
    #
    #   task :news => [:gem] do
    #     xf = Rake::XForge::NewsPublisher.new(project)
    #     ... # Set additional attributes
    #     xf.execute
    #   end
    class NewsPublisher < Base
      # A plain-text headline for the news byte to be published.
      attr_accessor :subject
      # The plain-text news to be published. Hyperlinks are usually
      # converted to hyperlinks by the xForge software.
      attr_accessor :details

      # Runs the news publisher task.
      def execute
        raise "'details' not defined." unless @details
        raise "'subject' not defined." unless @subject
        session = @project.login(user_name, password)
        session.publish_news(@subject, @details)
      end

    protected
      def set_defaults
        unless @subject
          if defined?(::PKG_NAME)
            if defined?(::PKG_VERSION)
              @subject = "#{::PKG_NAME} #{::PKG_VERSION} released"
            elsif defined?(@version)
              @subject = "#{::PKG_NAME} #{@version} released"
            end
          else
            if defined?(::PKG_VERSION)
              @subject = "#{@project.name} #{::PKG_VERSION} released"
            elsif defined?(@version)
              @subject = "#{@project.name} #{@version} released"
            end
          end
        end

        if @changes_file && @version
          begin
            vp = ::MetaProject::VersionParser.new
            version = vp.parse(@changes_file, @version)
            @details = version.release_notes unless @details
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
