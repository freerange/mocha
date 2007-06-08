module MetaProject
  module ScmWeb
    # A subset of the 
    # <a href="http://www.ruby-doc.org/stdlib/libdoc/pathname/rdoc/index.html">Pathname</a> 
    # API which is suitable for slurping SCM contents off the web.
    #
    class Pathname
            
      def initialize(browser, parent, basename, revision_identifier, directory)
        @browser, @parent, @basename, @revision_identifier, @directory = browser, parent, basename, revision_identifier, directory
      end
      
      # The relative path from the root of the browser instance
      #
      # ""
      # "var"
      # "var/spool"
      def path_from_root
        parent_path_from_root = @parent ? @parent.path_from_root : ""
        parent_path_from_root == "" ? @basename : "#{parent_path_from_root}/#{@basename}"
      end

      # The revision of this file or nil if this is a directory
      def revision_identifier
        @revision_identifier
      end

      # Returns a Pathname at the +relative_path+ from this directory.
      # Note: This only works if this instance is a +directory?+
      def child(basename, revision_identifier=nil, directory=true)
        raise "Can't create children for files" unless @directory
        Pathname.new(@browser, self, basename, revision_identifier, directory)
      end

      # Stlib Pathname methods
      
      # The parent of this instance
      def parent
        @parent
      end

      # The basename of this instance
      def basename
        @basename
      end

      # Returns the full path on the web (to the dir page for directories, history page for files)
      def cleanpath
        directory? ? @browser.dir(path_from_root) : @browser.history(path_from_root)
      end

      def children
        result = []
        html = better_open(cleanpath).read

        html.scan(@browser.child_dirs_pattern) do |child_basename_rev_array|
          child_basename = child_basename_rev_array[0]
          child_revision_identifier = child_basename_rev_array[1] # nil for most browsers
#puts "DIR:#{child_basename}:#{child_revision_identifier}"
          result << child(child_basename, child_revision_identifier, true)
        end

        html.scan(@browser.child_files_pattern) do |child_basename_rev_array|
          child_basename = child_basename_rev_array[0]
          child_revision_identifier = child_basename_rev_array[1]
#puts "FILE:#{child_basename}:#{child_revision_identifier}"
          result << child(child_basename, child_revision_identifier, false)
        end
        result
      end
      
      def open(&block)
        url = @browser.raw(path_from_root, revision_identifier)
        begin
          better_open(url, &block)
        rescue Errno::ECONNREFUSED => e
          # TODO: retry 2-3 times
          e.message += "(URL:#{url})"
          raise e
        end
      end
      
      def directory?
        @directory
      end
      
    end
  end
end