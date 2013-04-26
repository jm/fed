module Fed
  module Feed
    class Rss < Base
      def parse
        channel = @document.css('rss channel').first

        @title = channel.css('/title').text
        @description = channel.css('/description').text
        @link = channel.css('/link').text
        @updated = DateTime.parse(channel.css('/pubDate').text) rescue nil

        @entries = channel.css('item').map do |item|
          item_title = item.css('/title').text
          item_summary = item.css('/description').text
          item_content = item.css('/description').text
          item_link = item.css('/link').text
          item_published = DateTime.parse(item.css('/pubDate').text) rescue nil
          item_guid = item.css('/guid').text
          item_author = item.css('/author').text

          Entry.new(item_title, item_link, item_guid, item_published, item_author, item_summary, item_content)
        end

        self
      end
    end
  end
end