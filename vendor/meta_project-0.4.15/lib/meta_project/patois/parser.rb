module MetaProject
  # Patois is a domain specific language (DSL)
  # for configuration and release management. It was first implemented by 
  # <a href="http://projects.edgewall.com/trac/browser/trunk/contrib/trac-post-commit-hook">Trac</a>
  # and this class is a Ruby port of that Python code. 
  #
  # A similar idea was created by the DamageControl team in <a href="http://jira.codehaus.org/browse/DC-159">DC-159</a>
  # before it was implemented in Trac, but the Trac team beat the DamageControl to implement it.
  #
  # Anyhow, by giving this mini DSL a name and some better profiling we hope its adoption 
  # will increase. Patois means:
  # 
  # * a dialect other than the standard or literary dialect 
  # * uneducated or provincial speech
  # * the characteristic special language of an occupational or social group
  #
  # Patois' intended usage is in SCM commit messages. A patois-aware system can parse the commit
  # messages and try to recognise patois expressions and take appropriate actions.
  #
  # Here is a little taste of what you can say and do with Patois.
  #
  # == General form
  #
  #   command #1
  #   command #1, #2
  #   command #1 & #2
  #   command #1 and #2    # == Closing issues in an issue tracker
  #
  # You can have more than one command in a message. The following commands
  # are supported. There is more than one spelling for each command, to make
  # this as user-friendly as possible.
  #
  #   close, closed, closes, fix, fixed, fixes
  #     The specified issues are closed with the contents of the
  #     commit message being added to it.
  #
  #   addresses, re, ref, references, refs, see
  #     The specified issues are left in their current status, but
  #     the contents of the commit message are added to their notes.
  #
  # A fairly complicated example of what you can do is with a commit message
  # of:
  #
  #    Changed blah and foo to do this or that. Fixes #10 and #12, and refs #12.
  #
  # This will close #10 and #12, and add a note to #12
  #
  module Patois
    
    # Parses Patois
    #
    class Parser

      SUPPORTED_COMMANDS = {
        'close'      =>  ':close',
        'closed'     =>  ':close',
        'closes'     =>  ':close',
        'fix'        =>  ':close',
        'fixed'      =>  ':close',
        'fixes'      =>  ':close',
        'addresses'  =>  ':comment',
        're'         =>  ':comment',
        'ref'        =>  ':comment',
        'references' =>  ':comment',
        'refs'       =>  ':comment',
        'see'        =>  ':comment'
      }
      
      # Creates a new parser that will parse commands with +command_pattern+
      # and emit individual commands with +issue_pattern+.
      def initialize(command_pattern, issue_pattern)
        @command_pattern = command_pattern
        @issue_pattern = issue_pattern
      end

      # Parses a patois String and yields commands.
      # TODO: Each operation can be executed with +execute+
      def parse(msg)
        msg.scan(@command_pattern) do |cmd_group|
          cmd = SUPPORTED_COMMANDS[cmd_group[0].downcase]
          if(cmd)
            cmd_group[1].scan(@issue_pattern) do |issue_id_array|
              yield Command.new(cmd, issue_id_array[0].upcase, msg)
            end
          end
        end
      end
      
      class Command
        
        attr_reader :cmd, :issue_id, :msg

        def initialize(cmd, issue_id, msg)
          @cmd, @issue_id, @msg = cmd, issue_id, msg
        end
      end
    end
  end
end