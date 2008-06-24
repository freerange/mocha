module MetaProject
  module Project
    module XForge
      # A Session object allows authenticated interaction with a Project,
      # such as releasing files.
      #
      # A Session object can be obtained via Project.login
      class Session
        include HTTP::Multipart
        
        # Simple enumeration of processors. Used from Session.release.
        class Processor
          I386           = 1000
          IA64           = 6000
          ALPHA          = 7000
          ANY            = 8000
          PPC            = 2000
          MIPS           = 3000
          SPARC          = 4000
          ULTRA_SPARC    = 5000
          OTHER_PLATFORM = 9999
        end

        PACKAGE_ID_PATTERN  = %r{name="package_id"
                                 \s+
                                 value="([^"]+)"
                                 .*?
                                 name="package_name"
                                 \s+
                                 value="([^"]+)"}mxo #:nodoc:
        
        attr_reader :request_headers

        def initialize(host, project, cookie) # :nodoc:
          @host = host
          @project = project
          @request_headers = { "Cookie" => cookie }.merge(DEFAULT_POST_OPTIONS)
        end

        # This will get the +package_id+ for the project. This accepts an
        # optional name of the package that will be searched for results. A
        # given session will only work for one package.
        def package_id(name = nil)
          unless @package_id
            release_uri = "http://#{@host}/frs/admin/?group_id=#{@project.group_id}"
            release_data = better_open(release_uri, @request_headers).read
            packages = release_data.scan(PACKAGE_ID_PATTERN)
            first = packages[0][0]
            packages = Hash[*packages.map { |el| el.reverse }.flatten]

            if name
              @package_id = packages[name]
            else
              @package_id = first
            end
            
            unless @package_id
              File.open("package_id.html", "w") {|io| io.write(release_data)}
              raise "Couldn't get package_id from #{release_uri}. I was looking for /#{package_id_pattern.source}/. HTML saved to package_id.html for debugging." 
            end
          end
          @package_id
        end

        # Creates a new release containing the files specified by
        # +filenames+ (Array) and named +release_name+. Optional parameters
        # are +processor+ (which should be one of the Processor constants),
        # +release_notes+, +release_changes+ and +preformatted+ which will
        # appear on the releas page of the associated project. The
        # +package_name+ parameter will help choose from the possible
        # multiple packages for a release.
        # TODO: consider using a hash based signature with symbols. This is
        # getting big!
        def release(release_name, filenames, release_notes = "",
                    release_changes = "", package_name = nil,
                    preformatted = true, processor = Processor::ANY)
          release_date = Time.now.strftime("%Y-%m-%d %H:%M")
          release_id = nil

          puts "About to release '#{release_name}'"
          puts "Files:"
          puts "  " + filenames.join("\n  ")
          puts "\nRelease Notes:\n"
          puts release_notes.split(/\n/)[0..10].join("\n")
          puts "\nRelease Changes:\n"
          puts release_changes.split(/\n/)[0..10].join("\n")
          puts "\nRelease Settings:\n"
          puts "Preformatted: #{preformatted}"
          puts "Processor: #{processor}"
          puts "\nStarting release..."

          xfiles = filenames.collect{|filename| XFile.new(filename)}      
          xfiles.each_with_index do |xfile, i|
            first_file = (i == 0)
            puts "Releasing #{xfile.basename}..."
            release_response = Net::HTTP.start(@host, 80) do |http|
              query_hash = if first_file then
                {
                  "group_id" => @project.group_id,
                  "package_id" => package_id(package_name),
                  "type_id" => xfile.bin_type_id,
                  "processor_id" => processor,

                  "release_name" => release_name,
                  "release_date" => release_date,
                  "release_notes" => release_notes,
                  "release_changes" => release_changes,
                  "preformatted" => preformatted ? "1" : "0",
                  "submit" => "1"
                }
              else
                {
                  "group_id" => @project.group_id,
                  "package_id" => package_id(package_name),
                  "type_id" => xfile.bin_type_id,
                  "processor_id" => processor,

                  "step2" => "1",
                  "release_id" => release_id,
                  "submit" => "Add This File"
                }
              end

              form = [
                "--#{BOUNDARY}",
                %Q(Content-Disposition: form-data; name="userfile"; ) +
                  %Q(filename="#{xfile.basename}"),
                "Content-Type: application/octet-stream",
                "Content-Transfer-Encoding: binary",
                "", xfile.data, ""
              ]

              data = post_data(form, query_hash)

              headers = @request_headers.merge("Content-Type" => "multipart/form-data; boundary=#{BOUNDARY}")


              target = first_file ? "/frs/admin/qrs.php" : "/frs/admin/editrelease.php"
              http.post(target, data, headers)
            end

            if first_file then
              release_id = release_response.body[/release_id=(\d+)/, 1]
              raise("Couldn't get release id") unless release_id
            end
          end
          puts "Done!"
        end
    
        # Publish news relating to a project and a package.
        def publish_news(subject, details)
          puts "About to publish news"
          puts "Subject: '#{subject}'"
          puts "Details:"
          puts details
          puts ""
      
          release_response = Net::HTTP.start(@host, 80) do |http|
            query_hash = {
              "group_id" => @project.group_id,
              "post_changes" => "y",
              "summary" => subject,
              "details" => details
            }
      
            target = "/news/submit.php"
            headers = @request_headers.merge("Content-Type" => "multipart/form-data; boundary=#{BOUNDARY}")

            http.post(target, post_data(query_hash), headers)
          end
          puts "Done!"
        end

      end
    end
  end
end
