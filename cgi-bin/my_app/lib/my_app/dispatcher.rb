#coding: utf-8
require_relative 'response'
require_relative 'view'

module MyApp
  class Dispatcher
    attr_accessor :request, :path

    def dispatch
      ctrl = controller do |c|
        c.req = @request
        c.res = Response.new
        c.view = View.new(path_segments)
      end

      ctrl.do_task
      unless ctrl.res.content
        ctrl.res.content = ctrl.view.render
      end
      ctrl.res.content ||= 'text/html'
      ctrl.res
    end

    private

    def controller
      handler = (path_segments.unshift 'controller').join '/'
      require_relative handler
      klass = handler.split('/').map(&:capitalize).join '::'
      ctrl = Object.nested_const_get('MyApp::' + klass).new
      yield(ctrl) if block_given?
      ctrl
    end

    def path_segments
      @path ||= '/'
      segments = @path.split '/'
      segments.delete ''
      segments.empty? ? (segments << 'index') : segments
    end
  end

  # via http://blog.udzura.jp/2010/03/08/petit-hacking-about-const_get/
  class ::Object
    def self.nested_const_get(*args)
      stack = (args[0] =~ /::/) ? args[0].split("::") : args
      klass = Object
      while const = stack.shift
        klass = klass.const_get(const)
      end
      klass
    end
  end
end
