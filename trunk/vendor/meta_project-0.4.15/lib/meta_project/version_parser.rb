module MetaProject
  class VersionParser
    def parse(changes_file, version)
      release_notes_first = nil
      changes_first = nil
      changes_last = nil
  
      lines = File.open(changes_file).readlines
      state = nil
      lines.each_with_index do |line, n|
        # parse state
        if (line =~ /^==/ && state == :in_release_notes && state != :done)
          changes_first = changes_last = n
          state = :done
        end
        if line =~ /#{version}/ && state.nil?
          state = :in_release_notes
          release_notes_first = n+1
        end
        if (line =~ /^\*/ && state == :in_release_notes)
          state = :in_changes
          changes_first = changes_last = n
        end
        if (line =~ /^\*/ && state == :in_changes)
          changes_last = n
        end
        if (line =~ /^==/ && state == :in_changes)
          state = :done
        end
      end
  
      release_notes = lines[release_notes_first..changes_first-1].join("")
      raise "Release notes for #{version} couldn't be parsed from #{changes_file}" if release_notes.strip == ""

      release_changes = lines[changes_first..changes_last].collect do |line| 
        line.length >= 2 ? line[2..-1].chomp : line
      end
      raise "Release changes for #{version} couldn't be parsed from #{changes_file}" if release_changes.length == 0

      Version.new(release_notes, release_changes)
    end
  end

  class Version
    attr_reader :release_notes # String
    attr_reader :release_changes # Array of String

    def initialize(release_notes, release_changes)
      @release_notes, @release_changes = release_notes, release_changes
    end
  end
end
