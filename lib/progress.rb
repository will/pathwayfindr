class Progress
  require 'action_view/helpers/date_helper'
  include ActionView::Helpers::DateHelper
  
  def initialize(total, interval = 10)
    @total = total
    @interval = interval
    @count = 0
    @start = Time.now
  end
  
  def tick
    @count += 1
    if 0 == @count % @interval
      sofar = Time.now
      elapsed = sofar - @start
      puts "been running for #{distance_of_time_in_words(@start, sofar)}"
      rate = elapsed / @count
      puts "at a rate of #{distance_of_time_in_words(sofar, (sofar - rate), true)} per item"
      finish = sofar + ((@total * rate) - elapsed)
      puts "should finish around #{distance_of_time_in_words(sofar, finish)}"
    end
  end
end