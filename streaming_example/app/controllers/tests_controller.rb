class TestsController < ApplicationController
  #before_filter {|c| c.prepend_view_path(File.expand_path(File.dirname(__FILE__) + '/../templates')) }
  
  def massive
    @streaming = true
    print "we made it here!!!\n"
    respond_to do |format|
      format.csv 
    end
  end
  
  def massive_enum
    self.response_body = Enumerator.new do |y|
      10_000_000.times do |i|
        y << "This is line #{i}\n"
      end
    end
  end
  
  def massive_each
    self.response_body = Streamer.new
  end

end


class Streamer
  def each
    10_000_000.times do |i|
      yield "This is line #{i}\n"
    end
  end
end