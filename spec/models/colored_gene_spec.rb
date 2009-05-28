require File.dirname(__FILE__) + '/../spec_helper'

describe ColoredGene do
  before(:each) do
    @colored_gene = ColoredGene.new
    @colored_gene.gene = mock "some gene"
  end

  it "#new should optionally take a hash of options" do
    mock_gene = mock "some gene"
    cg = ColoredGene.new(:gene => mock_gene, :bg_color => "bg", :fg_color => "fg" )
    cg.gene.should == mock_gene
    cg.bg_color.should == "bg"
    cg.fg_color.should == "fg"
  end

  it "should have a gene" do
    mock_gene = mock "mock gene"
    @colored_gene.gene = mock_gene
    @colored_gene.gene.should == mock_gene
  end
  
  it "should proxy #entry_id to its gene" do
    mock_gene = mock "mock gene", :entry_id => "some entry id"
    @colored_gene.gene = mock_gene
    @colored_gene.entry_id.should == mock_gene.entry_id
  end
  
  it "should proxy #pathways to its gene" do
    mock_gene = mock "gene", :pathways => [1, 2]
    @colored_gene.gene = mock_gene
    @colored_gene.pathways.should == [1, 2]
  end
  
  it "should have a background color" do
    color = "red"
    @colored_gene.bg_color = color
    @colored_gene.bg_color.should == color
  end
  
  it "should have a foreground color" do
    color = "red"
    @colored_gene.fg_color = color
    @colored_gene.fg_color.should == color
  end
  
  it "should, with no gene, complain if asked for entry_id" do
    lambda { ColoredGene.new.entry_id }.should raise_error("No gene set")
  end
  
  it "should, with no gene, complain if asked for bg_color" do
    lambda { ColoredGene.new.bg_color }.should raise_error("No gene set")
  end
    
  it "should, with no gene, complain if asked for fg_color" do
    lambda { ColoredGene.new.fg_color }.should raise_error("No gene set")
  end
end
