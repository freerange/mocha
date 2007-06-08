module MetaProject
  module Tracker

    # Tracker objects are responsible for interacting with issue trackers (bug trackers).
    # They know how to recognise issue identifiers in strings (typically from SCM commit
    # messages) and turn these into HTML links that point to the associated issue on an
    # issue tracker installation running somewhere else.
    class Base
      def self.classes
        [
          Jira::JiraTracker,
          Trac::TracTracker,
          XForge::RubyForgeTracker,
          XForge::SourceForgeTracker,
        ]
      end

      def issue(issue_identifier)
        Issue.new(self, :identifier => issue_identifier)
      end

    end
  end
end