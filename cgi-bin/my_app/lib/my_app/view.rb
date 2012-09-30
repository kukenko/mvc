#coding: utf-8
require 'tilt'

module MyApp
  class View < Struct.new(:path_segments)
    attr_accessor :vars

    def render
      template = Tilt.new(template_file)
      template.render self, vars
    end

    private

    def template_file
      file = File.join('templates', path_segments)
      file += '.haml'
    end
  end
end
