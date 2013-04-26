
module Fed
  module Http
    class Curb
      def self.get(url)
        Curl.get(url) do|http|
          http.headers['User-Agent'] = Fed::Http.options[:user_agent]
          http.follow_location = true
        end.body_str
      end
    end
  end
end