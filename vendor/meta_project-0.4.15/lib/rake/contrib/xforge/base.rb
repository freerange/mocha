module Rake
  module XForge
    # Base class for XForge tasks.
    class Base
      # The user name for the xForge login of a release administrator of the
      # project being released. This should NOT be stored in the Rakefile.
      attr_accessor :user_name
      # The password for the xForge login of a release administrator of the
      # project being released. This should NOT be stored in the Rakefile.
      attr_accessor :password
      # The CHANGES file. If this file exists, it is parsed according to the
      # standard CHANGES version parsing routines. See CHANGES FORMAT below
      # for more information. Defaults to CHANGES if unset. #version must
      # also be set.
      #
      # === CHANGES FORMAT
      # The CHANGES file is essentially an RDoc-format changelog in the
      # form:
      #
      #   == Version VERSION-Pattern
      #
      #   RELEASE NOTES
      #
      #   * Change 1
      #   * Change 2
      attr_accessor :changes_file
      # Modifies the release version and affects CHANGES file parsing.
      attr_accessor :version

      def initialize(project)
        @project = project

        @changes_file = "CHANGES"
        @version = ::PKG_VERSION if defined?(::PKG_VERSION)
  
        if block_given?
          yield self
          set_defaults
          execute
        end
      end
      
    protected
      def set_defaults
      end
      
      def user_name
        unless @user_name
          print "#{@project.host} user: "
          @user_name = STDIN.gets.chomp
        end
        @user_name
      end

      def password
        unless @password
          print "#{@project.host} password: "
          @password = STDIN.gets.chomp
        end
        @password
      end
    end
  end
end
