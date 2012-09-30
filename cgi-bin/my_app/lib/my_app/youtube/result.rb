#coding: utf-8
require 'json'

module MyApp
  module YouTube
    class Result < Struct.new(:entries)
      def to_json
        data = entries.map do |e|
          {'title' => e.title, 'thumbnail' => e.thumbnail, 'link' => e.link}
        end
        JSON.generate data
      end
    end
  end
end
