#coding: utf-8
$:.unshift File.dirname(__FILE__) + "/my_app/lib/"
require 'my_app/youtube'
include MyApp::YouTube

MyApp::YouTube::search('cat').entries.each do |entry|
  puts entry.title
  puts entry.thumbnail
  puts entry.link, "\n"
end
