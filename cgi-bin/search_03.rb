#coding: utf-8
require 'cgi'
require 'httpclient'
require 'simple-rss'
require 'json'
require 'tilt'
require 'haml'

def search_videos(query)
  url = 'http://gdata.youtube.com/feeds/api/videos'
  client = HTTPClient.new
  res = client.get(url, {'vq' => query, 'orderby' => 'viewCount'})
  parse_videos(res.content)
end

def parse_videos(xml)
  SimpleRSS.parse(xml)
end

def json(xml)
  data = xml.entries.map do |e|
    {'title' => e.title, 'thumbnail' => e.media_thumbnail_url, 'link' => e.link}
  end
  JSON.generate data
end

cgi = CGI.new('html4Tr')
if cgi.include?('json') && cgi.include?('q')
  cgi.out do
    cgi.meta('http-equiv'=>'Content-Type','content'=>'application/json; charset=utf-8') +
    json(search_videos(cgi['q']))
  end
else
  cgi.out do
    file = cgi['q'].empty? ? 'templates/index.haml' : 'templates/result.haml'
    template = Tilt.new(file)
    entries = cgi['q'].empty? ? [] : search_videos(cgi['q']).entries
    template.render(self, :entries => entries)
  end
end
