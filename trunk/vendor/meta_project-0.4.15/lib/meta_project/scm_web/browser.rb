module MetaProject
  module ScmWeb

    # A Browser instance is capable of generating URLs to various files and diffs
    # in an online scm web interface.
    #
    class Browser

      attr_accessor :dir_spec, :history_spec, :raw_spec, :html_spec, :diff_spec

      # The variables to use in +uri_specs+ are:
      #
      # * path
      # * revision
      # * previous_revision
      #
      def initialize(dir_spec=nil, history_spec=nil, raw_spec=nil, html_spec=nil, diff_spec=nil, child_dirs_pattern=nil, child_files_pattern=nil)
        self.dir_spec     = dir_spec     unless dir_spec.nil?
        self.history_spec = history_spec unless history_spec.nil?
        self.raw_spec     = raw_spec     unless raw_spec.nil?
        self.html_spec    = html_spec    unless html_spec.nil?
        self.diff_spec    = diff_spec    unless diff_spec.nil?

        @child_dirs_pattern    = child_dirs_pattern
        @child_files_pattern   = child_files_pattern
      end
      
      def dir_spec=(spec)
        validate_presence_of("dir_spec", spec, "path")
        @dir_spec = spec
      end

      def history_spec=(spec)
        validate_presence_of("history_spec", spec, "path")
        @history_spec = spec
      end

      def raw_spec=(spec)
        validate_presence_of("raw_spec", spec, "path")
        validate_presence_of("raw_spec", spec, "revision")
        @raw_spec = spec
      end

      def html_spec=(spec)
        validate_presence_of("html_spec", spec, "path")
        validate_presence_of("html_spec", spec, "revision")
        @html_spec = spec
      end

      def diff_spec=(spec)
        validate_presence_of("diff_spec", spec, "revision")
        # Can't assume path and previous_revision to be present (Trac doesn't use them)
        #validate_presence_of("diff_spec", @diff_spec, "path")
        #validate_presence_of("diff_spec", @diff_spec, "previous_revision")
        @diff_spec = spec
      end

      def dir(path)
        file_uri(path, nil, @dir_spec, nil)
      end

      def history(path)
        file_uri(path, nil, @history_spec, nil)
      end

      def raw(path, revision)
        file_uri(path, revision, @raw_spec, nil)
      end

      def html(path, revision)
        file_uri(path, revision, @html_spec, nil)
      end

      def diff(path, revision, previous_revision)
        file_uri(path, revision, @diff_spec, previous_revision)
      end
      
      # The regexp used to determine child directories of a directory
      def child_dirs_pattern
        @child_dirs_pattern
      end

      # The regexp used to determine child files of a directory
      def child_files_pattern
        @child_files_pattern
      end

      # Returns a Pathname representing the root directory of this browser.
      # NOTE: The root of the browser may be at a lower level than
      # the toplevel of the online scm web interface; It depends
      # on the configuration of this instance.
      def root
        Pathname.new(self, nil, "", nil, true)
      end

    private

      def validate_presence_of(spec_name, spec, var)
        raise "Missing \#{#{var}} in #{spec_name}: '#{spec}'" unless spec =~ /\#\{#{var}\}/
      end

      def file_uri(path, revision, spec, previous_revision)
        begin
          eval("\"#{spec}\"", binding)
        rescue NameError
          raise "Couldn't evaluate '#{spec}'"
        end
      end

    end
  end
end