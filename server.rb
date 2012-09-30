require 'webrick'

document_root = File.expand_path('.')
rubybin = File.expand_path('~/.rbenv/shims/ruby')

server = WEBrick::HTTPServer.new({
    :DocumentRoot => document_root,
    :BindAddress => '0.0.0.0',
    :CGIInterpreter => rubybin,
    :Port => 8080
  })

['/cgi-bin/search_05.rb'].each do |cgi_file|
  server.mount(cgi_file, WEBrick::HTTPServlet::CGIHandler, document_root + cgi_file)
end

['INT', 'TERM'].each do |signal|
  Signal.trap(signal) { server.shutdown }
end

server.start
