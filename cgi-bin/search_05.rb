#coding: utf-8
$:.unshift File.dirname(__FILE__) + "/my_app/lib/"
require 'cgi'
require 'my_app/dispatcher'

cgi = CGI.new('html4Tr')
dispatcher = MyApp::Dispatcher.new
dispatcher.request = cgi
dispatcher.path = cgi.path_info
res = dispatcher.dispatch

cgi.out do
  cgi.meta('http-equiv' => 'Content-Typ', 'content' => res.content_type) +
  res.content
end


