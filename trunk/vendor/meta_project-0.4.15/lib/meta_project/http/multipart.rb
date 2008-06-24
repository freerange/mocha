module MetaProject
  module HTTP
    # TODO make this an extension of Net::HTTP and nicify the API
    module Multipart
      BOUNDARY = "rubyqMY6QN9bp6e4kS21H4y0zxcvoor" #:nodoc:

      def post_multipart(http, target, params, headers)
        headers = headers.merge("Content-Type" => "multipart/form-data; boundary=#{BOUNDARY}")
        http.post(target, post_data(params), headers)
      end

      # Converts an Array or Hash into HTTP POST params
      def post_data(*params)
        form = []
        params.each do |param|
          case param
          when Array
            form << param
          when Hash
            param.each do |key, value|
              form <<
                "--#{BOUNDARY}" <<
                %Q(Content-Disposition: form-data; name="#{key}") <<
                "" << value
            end
          end
        end
        form.flatten.join("\r\n")
      end
    end
  end
end