module Fed
  module Http
    class <<self
      attr_writer :options

      def options
        @options ||= {
          :user_agent => "fed (Ruby feed parser) v.#{Fed::VERSION}"
        }
      end

      attr_writer :client

      def client
        @client ||= Fed::Http::Curb
      end
    end
  end
end