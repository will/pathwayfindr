class Colorizer
  
  Colors = ["#FF0000", "#6464FF", "#FF6A00", "#FFFF00", "#FF0066", "#87F5FF", "#00FF00", "#C18CFF", "#FFAFAF", "#FFEB89"]
  
  def self.colorize pairs
    raise ArgumentError unless pairs.all? {|pair| pair.size == 2}

    pairs.inject [] do |acc, pair|
      acc << ColoredGene.new(:gene => pair.first, :bg_color => Colors[pair.last])
    end
  end
end
