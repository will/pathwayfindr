require File.dirname(__FILE__) + '/../spec_helper'

describe Colorizer do

describe "::colorize"  do
  
  it "should raise an ArgumentError if any of the elements is not a pair" do
    lambda { Colorizer.colorize [ ["this is", "a pair"], ["but this isn't"] ] }.should raise_error(ArgumentError)
    lambda { Colorizer.colorize [ ["this is", "a pair"], ["but", "this", "isn't"] ] }.should raise_error(ArgumentError)
    lambda { Colorizer.colorize [ ["not a pair"], ["a", "pair"] ] }.should raise_error(ArgumentError)
  end
  
  it "should return a ColoredGenes for each pair given" do
    input  = [ ["gene1", 0], ["gene2", 1], ["gene3", 0] ]
    output = Colorizer.colorize input
    output.each {|cg| cg.class.should == ColoredGene }
    output.size.should == input.size
  end
  
  it "should set the gene for each ColoredGene" do
    input  = [ ["gene1", 0], ["gene2", 1], ["gene3", 0] ]
    output = Colorizer.colorize input
    
    output[0].gene.should == "gene1"
    output[1].gene.should == "gene2"
    output[2].gene.should == "gene3"
  end
  
  it "should set a unique background color for each group" do    
    input  = [ ["gene1", 0], ["gene2", 1], ["gene3", 0] ]
    output = Colorizer.colorize input
    
    output.each { |cg| cg.bg_color.should_not be_nil }
    output[0].bg_color.should == output[2].bg_color
    output[0].bg_color.should_not == output[1].bg_color
  end
  
  it "should set the ColoredGene's background color from ::COLORS" do
    input  = [ ["gene1", 0], ["gene2", 1], ["gene3", 0] ]
    output = Colorizer.colorize input
    
    output[0].bg_color.should == Colorizer::Colors[0]
    output[1].bg_color.should == Colorizer::Colors[1]
  end
  
  it "should not set the ColoredGene's foreground color (so it is nil)" do
    input  = [ ["gene1", 0], ["gene2", 1], ["gene3", 0] ]
    output = Colorizer.colorize input
    
    output[0].fg_color.should be_nil
    output[1].fg_color.should be_nil
  end
  
  it "should set the ColoredGene's background color to nil if group number greater than the number of colors" do
    input = (0..15).inject([]) { |acc, i| acc<<["gene#{i}", i] }
    output = Colorizer.colorize input
    
    (0..9).each   { |i| output[i].bg_color.should_not be_nil }
    (10..15).each { |i| output[i].bg_color.should be_nil }
    
  end
end
  
describe "::Colors" do
  it "should be an array of hex colors" do
    Colorizer::Colors.each do |color|
      color.should =~ /^#[0-9A-F]{6}$/
    end
  end
end
  
end
