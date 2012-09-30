#coding: utf-8

module MyApp
  module Controller
    class Hello
      attr_accessor :req, :res, :view
      def do_task
        @res.content = 'Hello, MyApp!'
      end
    end
  end
end
