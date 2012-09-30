#coding: utf-8
require 'cgi'
require 'tilt'
$:.unshift File.dirname(__FILE__) + "/my_app/lib/"
require 'my_app/youtube'
include MyApp::YouTube

cgi = CGI.new('html4Tr')
if cgi.include?('json') && cgi.include?('q')
  cgi.out do
    cgi.meta('http-equiv'=>'Content-Type','content'=>'application/json; charset=utf-8') +
    MyApp::YouTube::search(cgi['q']).to_json
  end
else
  cgi.out do
    file = cgi['q'].empty? ? 'templates/index.haml' : 'templates/result.haml'
    template = Tilt.new(file)
    entries = cgi['q'].empty? ? [] : MyApp::YouTube::search(cgi['q']).entries
    template.render(self, :entries => entries)
  end
end
