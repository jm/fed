module Fed
  module Http
    module Errors
      class NotFound < StandardError; end

      class ServerError < StandardError; end

      class BadFeed < StandardError; end
    end
  end
end