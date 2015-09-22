# encoding: UTF-8
require 'fortitude'

module Forti
  def forti(widget, needs={})
#    puts "trying to Fortitude with class #{widget} and needs #{needs}"
    context = Fortitude::RenderingContext.new(helpers_object: self)
    widget.new(needs).to_html(context)
  end
end