module Fed
  module Feed
    class Atom < Base
      def parse
        feed = @document.css('feed').first

        @title = feed.css('/title').text
        @description = feed.css('/subtitle').text
        @link = feed.css('/link').first.attributes['href'].value
        @updated = DateTime.parse(feed.css('/updated').text) rescue nil

        @entries = feed.css('entry').map do |entry|
          entry_title = entry.css('/title').text
          entry_summary = entry.css('/summary').text
          entry_content = entry.css('/content').text
          entry_published = DateTime.parse(entry.css('/updated').text) rescue nil
          entry_guid = entry.css('/id').text
          entry_author = entry.css('/author name').map {|a| a.text}.join(', ')

          link_elem = entry.css("link[rel='alternate']").first
          entry_link = if (link_elem && (attribute = link_elem.attributes['href']))
            attribute.value
          else
            ""
          end

          enclosure_elem = item.css("link[rel='enclosure']").first
          entry_enclosure = if !enclosure_elem.nil?
            url = enclosure_elem.attributes['href'] ? enclosure_elem.attributes['href'].value : ''
            content_type = enclosure_elem.attributes['type'] ? enclosure_elem.attributes['type'].value : ''
            Enclosure.new(url, content_type)
          else
            nil
          end

          Entry.new(entry_title, entry_link, entry_guid, entry_published, entry_author, entry_summary, entry_content, entry_enclosure)
        end

        self
      end
    end
  end
end