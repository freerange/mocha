module MetaProject
  module Tracker
    # This module should be included by trackers that follow a digit-based issue scheme.
    # TODO: Make issue_pattern and command_pattern attributes so they can be modified. Provide examples.
    module DigitIssues
      # Patois issue pattern
      def issue_pattern
        @issue_pattern ||= /\#([\d]+)/
      end
      module_function :issue_pattern

      # Patois command pattern
      def command_pattern
        @command_pattern ||= /([A-Za-z]*).?(\#[\d]+(?:(?:[, &]*|\s?and\s?)\#[\d]+)*)/
      end
      module_function :command_pattern

      def identifier_examples
        ["#1926", "#1446"]
      end

      # TODO: find a way to extract just the issue summaries so they can be stored in dc as an array
      # embedded in the revision object. that way we don't alter the original commit message
      def markup(text)
        text.gsub(issue_pattern) do |match|
          issue_identifier = $1
          issue = issue(issue_identifier)
          link_text = (issue && issue.summary && issue.summary.strip! != "") ? "#{issue_identifier}: #{issue.summary}" : issue_identifier
          (issue && issue.url) ? "<a href=\"#{issue.url}\">\##{link_text}</a>" : "\##{issue_identifier}"
        end
      end
    end
  end
end