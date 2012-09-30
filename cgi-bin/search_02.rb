#coding: utf-8
require 'cgi'
require 'httpclient'
require 'simple-rss'
require 'json'

def search_videos(query)
  url = 'http://gdata.youtube.com/feeds/api/videos'
  client = HTTPClient.new
  res = client.get(url, {'vq' => query, 'orderby' => 'viewCount'})
  parse_videos(res.content)
end

def parse_videos(xml)
  SimpleRSS.parse(xml)
end

def thumbnail(cgi, entry)
  cgi.img('SRC' => entry.media_thumbnail_url)
end

def anchor(cgi, entry)
  cgi.a('HREF' => entry.link) do
    cgi.img('SRC' => entry.media_thumbnail_url)
  end
end

def json(xml)
  data = xml.entries.map do |e|
    {'title' => e.title, 'thumbnail' => e.media_thumbnail_url, 'link' => e.link}
  end
  JSON.generate data
end

style = <<EOF
ul li {
  list-style-type: none;
  display: inline;
}
EOF

cgi = CGI.new('html4Tr')
if cgi.include?('json') && cgi.include?('q')
  cgi.out do
    cgi.head('TYPE' => 'application/json', 'CHARSET' => 'utf-8') +
    json(search_videos(cgi['q']))
  end
else
  cgi.out do
    cgi.head('TYPE' => 'text/html', 'CHARSET' => 'utf-8') do
      cgi.title { 'YouTube Search' } + cgi.style { style }
    end +
    cgi.body do
      cgi.h1 { 'YouTube Search' } +
      cgi.form('get') do
      cgi.text_field('q', cgi['q'] ? cgi['q'] : '') +
        cgi.submit({ 'VALUE' => '検索' })
      end +
      if cgi['q'].empty?
        ''
      else
        cgi.h2 { '検索結果' } +
        cgi.ul do
          search_videos(cgi['q']).entries.map do |entry|
            cgi.li { anchor(cgi, entry) }
          end.join
        end
      end
    end
  end
end
