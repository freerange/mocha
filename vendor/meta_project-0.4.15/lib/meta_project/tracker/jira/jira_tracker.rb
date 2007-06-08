require 'xmlrpc/client'

module MetaProject
  module Tracker
    module Jira
      
      # Interface to JIRA. Uses the XML-RPC API defined at:
      #
      # http://www.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/xmlrpc/XmlRpcService.html
      # http://confluence.atlassian.com/pages/viewpage.action?pageId=9623
      # http://confluence.atlassian.com/pages/viewpage.action?pageId=1035
      class JiraTracker < Base
        
        include JiraIssues
        JIRA_API = "jira1"
      
        attr_accessor :jira_base_url, :jira_project_id
      
        # Creates a new JiraTracker. In order to successfully get issue info (via XMLRPC),
        # two env vars must be defined. Example:
        #
        #   JiraTracker.new("http://jira.codehaus.org", "DC")
        #
        # Then the following must be defined:
        #
        #   JIRA_CODEHAUS_ORG_JIRA_USER
        #   JIRA_CODEHAUS_ORG_JIRA_PASSWORD
        #   TODO: pass in to ctor instead. do this somewhere else!
        def initialize(jira_base_url=nil, jira_project_id=nil)
          @jira_base_url, @jira_project_id = jira_base_url, jira_project_id
        end

        def overview
          "#{@jira_base_url}/browse/#{@jira_project_id}"
        end

        def create(issue)
          issue_struct = {
            "project" => @jira_project_id,
            "summary" => issue.summary,
            "description" => issue.detail,
            "type" => 2, # magic number!
            "priority" => 1
          }
          login do |session|
            issue_struct = session.createIssue(issue_struct)
            issue.attributes[:identifier] = issue_struct["key"]
            issue
          end
        end
        
        def close(issue)
          begin
            issue_struct = {
              "project" => @jira_project_id,
              "summary" => issue.summary,
              "description" => issue.detail,
              "type" => 2, # magic number!
              "priority" => 1,
              "status" => 6 # magic number for closed? do we have to look it up?
            }
            login do |session|
              # TODO: Can't close JIRA issue.
              # The following method:
              # http://www.atlassian.com/software/jira/docs/api/rpc-jira-plugin/latest/com/atlassian/jira/rpc/xmlrpc/XmlRpcService.html#updateIssue(java.lang.String,%20java.lang.String,%20java.util.Hashtable)
              # doesn't seem to exist on the JIRA on Codehaus (older version probably)
              issue_struct = session.updateIssue(issue.identifier, issue_struct)
              issue.attributes[:identifier] = issue_struct["key"]
              issue
            end
          rescue XMLRPC::FaultException => e
            # Probably bad issue number. Don't set URL.
            STDERR.puts("WARNING: Exception from JIRA while closing issue #{issue.identifier}: #{e.faultCode}, #{e.faultString}")
          end
        end
        
        def materialize(issue)
          issue.attributes[:identifier] = issue.attributes[:identifier].upcase

          # Getting summary and detail requires login
          begin
            login do |session|
              issue_struct = session.getIssue(issue.identifier)            
              issue.attributes[:url] = "#{@jira_base_url}/browse/#{issue.identifier}"
              issue.attributes[:summary] = issue_struct["summary"] ? issue_struct["summary"].strip : nil
              issue.attributes[:detail] = issue_struct["description"] ? issue_struct["description"].strip : nil
            end
          rescue JiraEnvVarException => e
            # Couldn't log in because of missing login info. Assume issue exists
            issue.attributes[:url] = "#{@jira_base_url}/browse/#{issue.identifier}"
            STDERR.puts("WARNING: #{e.message}")
          rescue XMLRPC::FaultException => e
            # Probably bad issue number. Don't set URL.
            STDERR.puts("WARNING: Exception from JIRA while loading issue details for #{issue.identifier}: #{e.faultCode}, #{e.faultString}")
          end
          issue
        end
        
      private
            
        def login
          client = XMLRPC::Client.new2("#{@jira_base_url}/rpc/xmlrpc")
          token = client.call("#{JIRA_API}.login", user, password)
          yield Session.new(client, token)
        end
        
        def user
          var = "#{login_env_var_prefix}_JIRA_USER"
          ENV[var] || missing_env_var(var)
        end

        def password
          var = "#{login_env_var_prefix}_JIRA_PASSWORD"
          ENV[var] || missing_env_var(var)
        end
        
        def login_env_var_prefix
          if(jira_base_url =~ /http:\/\/([^\/]+)/)
            $1.gsub(/\./, "_").upcase
          else
            raise "Bad jira_base_url: #{jira_base_url}"
          end
        end

        def missing_env_var(var)
          raise JiraEnvVarException.new("Couldn't log in to JIRA at #{@rooturl}: The " +
          "#{var} environment variable must be set in order to communicate with JIRA")
        end
        
        class JiraEnvVarException < Exception
        end
        
        # This wrapper around XMLRPC::Client that allows simpler method calls
        # via method_missing and doesn't require to manage the token
        class Session
          def initialize(client, token)
            @client, @token = client, token
          end

          def method_missing(sym, *args, &block)
            token_args = [@token] + args
            xmlrpc_method = "#{JIRA_API}.#{sym.to_s}"
            @client.call(xmlrpc_method, *token_args)
          end
        end
      end
    end
  end
end