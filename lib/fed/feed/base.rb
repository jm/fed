module Fed
  module Feed
    class Base
      attr_reader :document, :title, :description, :link, :guid, :updated, :entries

      def initialize(doc)
        @document = doc
      end
    end
  end
end