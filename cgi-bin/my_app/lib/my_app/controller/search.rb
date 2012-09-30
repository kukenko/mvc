#coding: utf-8
require_relative '../youtube'

module MyApp
  module Controller
    class Search
      include MyApp::YouTube
      attr_accessor :req, :res, :view
      def do_task
        entries = @req['q'].empty? ? [] : search(@req['q']).entries
        @view.vars = { :entries => entries }
      end
    end
  end
end
