module MetaProject
  module Project
    module XForge
      class XForgeBase < Base

        attr_reader :host, :unix_name

        # TODO: hash based constructor (big now)
        def initialize(host, unix_name, cvs_mod)
          @host = host
          @unix_name = unix_name
          @name = unix_name
          @cvs_mod = cvs_mod

          @tracker = tracker_class.new(group_id_uri("tracker"), self)

          unless(cvs_mod.nil?)
            @scm = create_cvs(unix_name, @cvs_mod)
            @scm_web = create_view_cvs(unix_name, @cvs_mod)
          end
        end

        def to_yaml_properties
          ["@host", "@unix_name"]
        end

        # Logs in and returns a Session
        def login(user_name, password)
          url = "/account/login.php"
          data = [
            "return_to=",
            "login=Login",
            "form_loginname=#{user_name}",
            "form_pw=#{password}"
          ].join("&")

          http = Net::HTTP.new(@host, 80)
          login_response, body = http.start do |http|
            http.post(url, data, DEFAULT_POST_OPTIONS)
          end

          cookie = login_response["set-cookie"]
          unless cookie
            raise "Login failed.\nURL:#{url}\nParams:#{data}\nResponse:#{login_response.to_hash.inspect}"
          end
          Session.new(@host, self, cookie)
        end

        # The group_id of this project
        def group_id
          unless(@group_id)
            html = better_open(xforge_project_url).read
            group_id_pattern = /project\/memberlist.php\?group_id=(\d+)/
            @group_id = html[group_id_pattern, 1]
            raise "Couldn't get group_id from #{xforge_project_url}. I was looking for /#{group_id_pattern.source}/" unless @group_id
          end
          @group_id
        end

        def xforge_project_url
          "http://#{@host}/projects/#{@unix_name}/"
        end

        def group_id_uri(path, postfix="")
          "http://#{@host}/#{path}/?group_id=#{group_id}#{postfix}"
        end

        # The home page of this project
        def home_page
          unless(@home_page)
            html = better_open(xforge_project_url).read
            @home_page = html[home_page_regexp, 1]
            unless @home_page
              STDERR.puts "WARNING: Couldn't get home_page from #{xforge_project_url}. I was looking for /#{home_page_regexp.source}/"
              STDERR.puts "Will use #{xforge_project_url} as home page instead."
              @home_page = xforge_project_url
            end
          end
          @home_page
        end

      end
    end
  end
end
