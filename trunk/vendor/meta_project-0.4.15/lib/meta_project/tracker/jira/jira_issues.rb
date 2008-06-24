module MetaProject
  module Tracker
    module Jira
      # This module should be included by trackers that follow a digit-based issue scheme
      module JiraIssues

        # Patois issue pattern
        def issue_pattern
          /([A-Za-z]+-[\d]+)/
        end
        module_function :issue_pattern

        # Patois command pattern
        def command_pattern
          /([A-Za-z]*).?([A-Za-z]+-[\d]+(?:(?:[, &]*|\s?and\s?)[A-Za-z]+-[\d]+)*)/
        end
        module_function :command_pattern

        def identifier_examples
          ["DC-420", "pico-12"]
        end

        def markup(text)
          text.gsub(issue_pattern) do |match|
            issue_identifier = $1.upcase
            issue = issue(issue_identifier)
            link_text = (issue.summary && issue.summary.strip! != "") ? "#{issue_identifier}: #{issue.summary}" : issue_identifier
            issue.url ? "<a href=\"#{issue.url}\">#{link_text}</a>" : issue_identifier
          end
        end

      end
    end
  end
end