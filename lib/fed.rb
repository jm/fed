$:.unshift(File.dirname(__FILE__))

require 'curb'
require 'nokogiri'
require 'time'

require 'fed/http'
require 'fed/http/errors'
require 'fed/http/curb'
require 'fed/feed/base'
require 'fed/feed/atom'
require 'fed/feed/rss1'
require 'fed/feed/rss2'
require 'fed/feed/entry'

module Fed
  VERSION = '0.0.5'

  class <<self

    def fetch_and_parse(feed_url)
      parse fetch(feed_url)
    end

    def fetch(feed_url)
      response = Fed::Http.client.get(feed_url)
      
      raise Fed::Http::Errors::NotFound if response == 404
      raise Fed::Http::Errors::ServerError unless response.is_a?(String)

      response
    end

    def parse(xml)
      document = Nokogiri::XML(xml)
      parser_for(document).parse
    end

    def parser_for(doc)
      if is_atom?(doc)
        Fed::Feed::Atom.new(doc)
      elsif is_rss2?(doc)
        Fed::Feed::Rss2.new(doc)
      elsif is_rss1?(doc)
        Fed::Feed::Rss1.new(doc)
      elsif (new_url = find_link_in_html(doc))
        parser_for(fetch(new_url))
      else
        raise Fed::Http::Errors::BadFeed  
      end
    end

    def is_atom?(document)
      document.css('feed entry').any?
    end

    def is_rss1?(document)
      document.xpath('/rdf:RDF').any? rescue false
    end

    def is_rss2?(document)
      document.css('rss channel').any?
    end

    def find_link_in_html(document)
      elems = document.css("link[type='application/atom+xml']")

      if elems.any?
        elems.first.attributes['href'].value
      else
        nil
      end
    end

  end
end