require File.dirname(__FILE__) + '/../spec_helper'

describe MarkedPathway do
it "should be able to set the pathway on creation" do
  pathway = mock "pathway"
  
  mp = MarkedPathway.new :pathway => pathway
  mp.pathway.should == pathway
end

it "should be able to set an array of colored genes on creation" do
  genes = [mock("gene1"), mock("gene2")]
  
  mp = MarkedPathway.new :genes => genes
  mp.genes.should == genes
end

it "should set genes to an empty array if not set on creation" do
  MarkedPathway.new.genes.should == []
end

describe "#pathway_id" do
  it "should get the entry_id from the pathway" do
    pathway = mock "pathway", :entry_id => "some entry id"
    mp = MarkedPathway.new :pathway => pathway
    
    mp.pathway_id.should == "some entry id"
  end
  
  it "should return nil if there's no pathway" do
    MarkedPathway.new.pathway_id.should be_nil
  end
end

describe "#gene_list" do
  it "should return an array of all the gene's entry_ids" do
    genes = (1..3).inject([]) {|acc, i| acc << mock("gene#{i}", :entry_id => "gene#{i}")}
    
    mp = MarkedPathway.new :genes => genes
    mp.gene_list.should == %w[ gene1 gene2 gene3 ]
  end
  
  it "should return an empty array if there are no genes" do
    MarkedPathway.new.gene_list.should == []
  end
end

describe "#bg_colors" do
  it "should return an array of all the gene's bg_colors" do
    genes = (1..3).inject([]) {|acc, i| acc << mock("gene#{i}", :bg_color => "color#{i}")}
    
    mp = MarkedPathway.new :genes => genes
    mp.bg_colors.should == %w[ color1 color2 color3 ]
  end
  
  it "should return an empty array if there are no genes" do
    MarkedPathway.new.bg_colors.should == []
  end
end

describe "#fg_colors" do
  it "should return an array of all the gene's fg_colors" do
    genes = (1..3).inject([]) {|acc, i| acc << mock("gene#{i}", :fg_color => "color#{i}")}
    
    mp = MarkedPathway.new :genes => genes
    mp.fg_colors.should == %w[ color1 color2 color3 ]
  end
  
  it "should return an empty array if there are no genes" do
    MarkedPathway.new.fg_colors.should == []
  end
end

describe "#get_image_url" do
  before(:each) do
    @mock_api = mock "kegg api"
    Bio::KEGG::API.stub!(:new).and_return @mock_api
    @mock_api.stub! :color_pathway_by_objects
  end
  
  it "should create a new KEGG API connection" do
    Bio::KEGG::API.should_receive(:new).and_return @mock_api
    MarkedPathway.new.get_image_url
  end
  
  it "should ask kegg for the url of the colored pathway" do
    @mock_api.should_receive :color_pathway_by_objects
    MarkedPathway.new.get_image_url
  end
end
end
