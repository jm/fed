
module Fed
  module Http
    class Curb
      def self.get(url)
        c = Curl.get(url) do|http|
          http.headers['User-Agent'] = Fed::Http.options[:user_agent]
          http.follow_location = true
        end

        c.status == "200 OK" ? c.body_str : c.status.to_i
      end
    end
  end
end