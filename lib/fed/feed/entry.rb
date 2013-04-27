module Fed
  module Feed
    class Entry < Struct.new(:title, :link, :guid, :published, :author, :summary, :content, :enclosure)
    end
  end
end