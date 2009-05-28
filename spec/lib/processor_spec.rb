require File.dirname(__FILE__) + '/../spec_helper'

describe Processor do
  
  describe "#find_marked_pathway" do
    before :each do 
      @mock_pathway = mock "pathway", :entry_id => "path:hsa1"
      @p = Processor.new
    end
    
    it "should return the marked pathway matching the entry_id of the pathway given" do
      marked_pathway = MarkedPathway.new :pathway => @mock_pathway
      @p.marked_pathways << marked_pathway
      result = @p.find_marked_pathway @mock_pathway
      result.should == marked_pathway
    end
    
    it "should make a new MarkedPathway and add it if it doesn't exist, and return the new marked pathway" do
      @p.marked_pathways.should be_empty
      result = @p.find_marked_pathway @mock_pathway
      result.pathway_id.should == @mock_pathway.entry_id
      @p.marked_pathways.should == [result]
    end
  end
  
  it "#process should create the marked pathways and add the genes to each and return the marked pathways" do
    mock_p_1  = mock "pathway 1", :entry_id => "path:hsa1"
    mock_p_2  = mock "pathway 2", :entry_id => "path:hsa2"
    mock_p_3  = mock "pathway 3", :entry_id => "path:hsa3"
    mock_cg_1 = mock "colored 1", :pathways => [mock_p_1, mock_p_2]
    mock_cg_2 = mock "colored 2", :pathways => [mock_p_2, mock_p_3]
    
    # p = Processor.new [mock_cg_1, mock_cg_2]
    # p.process
    # result = p.marked_pathways
    result = Processor.new.process [mock_cg_1, mock_cg_2]
    
    result.size.should == 3

    marked_1 = result.find {|mp| mp.pathway_id == mock_p_1.entry_id}
    marked_2 = result.find {|mp| mp.pathway_id == mock_p_2.entry_id}
    marked_3 = result.find {|mp| mp.pathway_id == mock_p_3.entry_id}
    
    marked_1.genes.should == [mock_cg_1]
    marked_2.genes.should == [mock_cg_1, mock_cg_2]
    marked_3.genes.should == [mock_cg_2]   
  end
  
end