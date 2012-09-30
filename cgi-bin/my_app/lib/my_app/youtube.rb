#coding: utf-8
require 'httpclient'
require 'simple-rss'
require_relative 'youtube/result'

module MyApp
  module YouTube
    def search(query)
      url = 'http://gdata.youtube.com/feeds/api/videos'
      client = HTTPClient.new
      res = client.get(url, {'vq' => query, 'orderby' => 'viewCount'})
      parse_videos(res.content)
    end

    def parse_videos(xml)
      feed = SimpleRSS.parse(xml).entries.each do |entry|
        entry.instance_eval do
          def thumbnail
            self.media_thumbnail_url.gsub(/0.jpg/, '2.jpg')
          end
        end
      end
      Result.new(feed.entries)
    end
  end
end
