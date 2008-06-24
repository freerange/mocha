module MetaProject
  module Project
    module XForge

      class XFile # :nodoc:

        # extension => [mime_type, rubyforge_bin_type_id, rubyforge_src_type_id]
        FILE_TYPES = {
          ".deb"  => ["application/octet-stream", 1000],

          # all of these can be source or binary
          ".rpm"  => ["application/octet-stream", 2000, 5100],
          ".zip"  => ["application/octet-stream", 3000, 5000],
          ".bz2"  => ["application/octet-stream", 3100, 5010],
          ".gz"   => ["application/octet-stream", 3110, 5020],
          ".jpg"  => ["application/octet-stream", 8000],
          ".jpeg" => ["application/octet-stream", 8000],
          ".txt"  => ["text/plain", 8100, 8100],
          ".html" => ["text/html", 8200, 8200],
          ".pdf"  => ["application/octet-stream", 8300],
          ".ebuild"  => ["application/octet-stream", 1300],
          ".exe"  => ["application/octet-stream", 1100],
          ".dmg"  => ["application/octet-stream", 1200],
          ".gem"  => ["application/octet-stream", 1400],
          ".sig"  => ["application/octet-stream", 8150]
        }
        FILE_TYPES.default = ["application/octet-stream", 9999, 5900] # default to "other", "other source"

        attr_reader :basename, :ext, :content_type, :bin_type_id, :src_type_id

        def initialize(filename)
          @filename = filename
          @basename = File.basename(filename)
          @ext = File.extname(filename)
          @content_type = FILE_TYPES[@ext][0]
          @bin_type_id = FILE_TYPES[@ext][1]
        end

        def data
          File.open(@filename, "rb") { |file| file.read }
        end
      end
    end
  end
end