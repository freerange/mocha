module MetaProject
  module Tracker
    
    # An issue represents an entry in an issue tracker such as a bug report or
    # feature request.
    class Issue
      attr_reader :attributes
    
      def initialize(tracker, attributes={})
        @tracker = tracker
        @attributes = attributes
      end
      
      # An URL pointing to the issue in the associated tracker, or nil if
      # the issue doesn't exist.
      def url
        @tracker.materialize(self) unless @attributes[:url]
        @attributes[:url]
      end

      # The id of the issue in the tracker
      def identifier
        @tracker.materialize(self) unless @attributes[:identifier]
        @attributes[:identifier]
      end

      # The summary of the issue (typically a one-liner)
      def summary
        @tracker.materialize(self) unless @attributes[:summary]
        @attributes[:summary]
      end

      # The details of the issue (typically several lines)
      def detail
        @tracker.materialize(self) unless @attributes[:detail]
        @attributes[:detail]
      end

      # Adds a comment (consisting of the +detail+) to the issue
      def update(user_name, password)
        @tracker.update(self, user_name, password)
      end

      # Creates a new issue (consisting of the +summary+ and +detail+)
      def create(user_name, password)
        raise "Summary not set" unless summary
        raise "Detail not set" unless detail
        @tracker.create(self, user_name, password)
      end

      # Closes the issue (adding a comment consisting of the +detail+)
      def close(user_name, password)
        @tracker.close(self, user_name, password)
      end
    end
  end
end