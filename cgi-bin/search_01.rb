#coding: utf-8
require 'cgi'
require 'httpclient'
require 'simple-rss'

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
    cgi.img('SRC' => entry.media_thumbnail_url, 'TITLE' => entry.title)
  end
end


style = <<EOF
ul li {
  list-style-type: none;
  display: inline;
}
EOF

cgi = CGI.new('html4Tr')
cgi.out do
  cgi.head { cgi.title { 'YouTube Search' } + cgi.style { style } } +
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
