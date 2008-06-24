# Copyright (C) 2005 Thomas Leitner
#
# See LICENCE for details

require "xmlrpc/client"
require 'yaml'

module DevTools

  module Freshmeat

    class FreshmeatException < StandardError; end

    # Describes a freshmeat project.
    class Project

      # The short name of the project
      attr_reader :shortName

      # The full name of the project
      attr_reader :fullName

      # The status of the project (alpha, beta, ...)
      attr_reader :status

      # The current version string of the project
      attr_reader :version

      def initialize( shortName, fullName, status, version )
        @shortName, @fullName, @status, @version = shortName, fullName, status, version
      end

      def to_s
        "Project: short name = #{@shortName}, full name = #{@fullName}, status = #{@status}, version = #{@version}"
      end

    end

    # Provides information about a release.
    class ReleaseInfo

      # Version string of release
      attr_reader :version

      # Change list of release
      attr_reader :changes

      # Release focus
      attr_reader :release_focus

      # True, if hidden from frontpage
      attr_reader :hidden

      # Returns a new ReleaseInfo object
      def initialize( version, changes, release_focus, hidden )
        @version, @changes, @release_focus, @hidden = version, changes, release_focus, hidden
      end

      def to_s
        "ReleaseInfo: version = #{@version}, release focus = #{ReleaseFocusID::NAMES[@release_focus]}, hidden = #{hidden}\nChanges = #{@changes}"
      end

    end

    # Holds all information about a release which should be published.
    class Release

      #Project name to submit a release for
      attr_accessor :project_name

      #Branch name to submit a release for
      attr_accessor :branch_name

      #Version string of new release
      attr_accessor :version

      #Changes list, no HTML, character limit 600 chars
      attr_accessor :changes

      #Release focus ID of new release
      attr_accessor :release_focus

      #Set to 'Y' if release is to be hidden from frontpage, everything else does not hide it
      attr_accessor :hide_from_frontpage

      #Optional: Branch license
      attr_accessor :license

      #Optional: Homepage
      attr_accessor :url_homepage

      #Optional: Tar/GZ
      attr_accessor :url_tgz

      #Optional: Tar/BZ2
      attr_accessor :url_bz2

      #Optional: Zip
      attr_accessor :url_zip

      #Optional: Changelog
      attr_accessor :url_changelog

      #Optional: RPM package
      attr_accessor :url_rpm

      #Optional: Debian package
      attr_accessor :url_deb

      #Optional: OS X package
      attr_accessor :url_osx

      #Optional: BSD Ports URL
      attr_accessor :url_bsdport

      #Optional: Purchase
      attr_accessor :url_purchase

      #Optional: CVS tree (cvsweb)
      attr_accessor :url_cvs

      #Optional: Mailing list archive
      attr_accessor :url_list

      #Optional: Mirror site
      attr_accessor :url_mirror

      #Optional: Demo site
      attr_accessor :url_demo

      def self.from_data( data=nil )
        YAML::load( data )
      end

      def to_rpc_data
        rpc_data = {}
        instance_variables.each do |iv|
          rpc_data[iv[1..-1]] = eval( iv )
        end
        rpc_data
      end

      def to_yaml_type
        "!thomasleitner,2005/FreshmeatRelease"
      end

      YAML::add_domain_type( 'thomasleitner,2005', 'FreshmeatRelease' ) do |type, val|
        YAML::object_maker( Release, val )
      end

    end

    # Provides constants for all release focus ids
    module ReleaseFocusID
      NA                   = 0
      INITIAL_ANNOUNCEMENT = 1
      DOCUMENTATION        = 2
      CODE_CLEANUP         = 3
      MINOR_FEATURES       = 4
      MAJOR_FEATURES       = 5
      MINOR_BUGFIXES       = 6
      MAJOR_BUGFIXES       = 7
      MINOR_SECFIXES       = 8
      MAJOR_SECFIXES       = 9

      NAMES = {0=>'N/A',
               1=>'Initial freshmeat announcement',
               2=>'Documentation',
               3=>'Code cleanup',
               4=>'Minor feature enhancements',
               5=>'Major feature enhancements',
               6=>'Minor bugfixes',
               7=>'Major bugfixes',
               8=>'Minor security fixes',
               9=>'Major security fixes'
      }
    end


    # Provides access to the Freshmeat XML-RPC API via a nice interface.
    # API reference at http://freshmeat.net/faq/view/49/
    #
    # Example:
    #
    #   fm = DevTools::FreshmeatService.new( username, password )
    #   fm.get_project_list.each do |p|
    #     puts p
    #     branches = fm.get_branch_list( p.shortName )
    #     puts branches.inspect
    #     release = fm.get_release( p.shortName, branches[0], p.version )
    #     puts release
    #   end
    #   puts fm.logout
    class FreshmeatService

      # The URL for the Freshmeat RPC service
      RPCURL = 'http://freshmeat.net/xmlrpc/'

      # The major version of the freshmeat API with which this library works
      API_VERSION_MAJOR = '1'

      # The minor version of the freshmeat API with which this library works
      API_VERSION_MINOR = '03'

      # Use +username+ and +password+ to log into Freshmeat service.
      def initialize( username, password )
        @session = XMLRPC::Client.new2( RPCURL )
        ret = @session.call( :login, :username=>username, :password=>password )
        @sid = ret['SID']
        major, minor = ret['API Version'].split( '.' )
        if major != API_VERSION_MAJOR or minor < API_VERSION_MINOR
          raise FreshmeatException, 'Incompatible API versions'
        end
      end

      # Returns all available licenses
      def self.get_licenses
        XMLRPC::Client.new2( RPCURL ).call( :fetch_available_licenses )
      end

      # Returns all available release focus types
      def self.get_release_focus_types
        XMLRPC::Client.new2( RPCURL ).call( :fetch_available_release_foci )
      end

      # Returns an array of Project objects which are assigned to the logged in user
      def get_project_list
        ret = @session.call( :fetch_project_list, :SID=>@sid )
        ret.collect! {|p| Project.new( p['projectname_short'], p['projectname_full'], p['project_status'], p['project_version'] ) }
      end

      # Returns an array of branch names for the project +project+.
      def get_branch_list( project )
        @session.call( :fetch_branch_list, :SID=>@sid, :project_name=>project )
      end

      # Returns a ReleaseInfo object which has the information about the requested release.
      def get_release( project, branch, version )
        ret = @session.call( :fetch_release, :SID=>@sid, :project_name=>project, :branch_name=>branch, :version=>version )
        releaseFocus = ret['release_focus'].split( ' - ' )[0].to_i
        hidden = (ret['hide_from_frontpage'] == 'Y' )
        ReleaseInfo.new( ret['version'], ret['changes'], releaseFocus, hidden )
      end

      # Publishes a new release of a project. The parameter +release+ has to be a Release object!
      def publish_release( release )
        ret = @session.call( :publish_release, {:SID=>@sid}.update( release.to_rpc_data ) )
        ret['OK'] == 'submission successful'
      end

      # Withdraws the specified release.
      def withdraw_release( project, branch, version )
        ret = @session.call( :withdraw_release, :SID=>@sid, :project_name=>project, :branch_name=>branch, :version=>version )
        ret['OK'] == 'Withdraw successful.'
      end

      # Logs out from the Freshmeat service.
      def logout
        ok, ret = @session.call2( :logout, :SID=>@sid )
        ok && ret['OK'] == 'Logout successful.'
      end

    end

  end

end
