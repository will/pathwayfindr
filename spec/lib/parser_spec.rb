require File.dirname(__FILE__) + '/../spec_helper'

describe Parser do

describe "#initialize" do
  it "should set @filename" do
    filename = "some/path/and/file"
    parser = Parser.new filename
    parser.filename.should == filename
  end
  
  it "should set @lines to an empty string" do
    parser = Parser.new 'whatever'
    parser.lines.should be_empty
  end
end

describe "#import" do
  it "should return self" do
    file = [["gene", "group"]].to_test_file
    parser = Parser.new file
    parser.import.should == parser
  end
  
  it "should create an array of the first two columns in @lines" do
    file = [ 
      [ "gene 1", "group1", "extra columns", "that", "shouldn't", "show up" ],
      [ "GENE2",  "group1" ],
      [ "gene3",  "group 2!", "last one didn't have any extra columns" ]
    ].to_test_file
    
    parser = Parser.new file
    parser.import
    
    parser.lines.should == [ [ "gene 1", "group1"  ],
                             [ "GENE2",  "group1"  ],
                             [ "gene3",  "group 2!"] ]
  end
  
  it "should add an empty string if there is no second column" do
    file = [
      [ "gene 1", "group 1", "this one has the second col ... and a third" ],
      [ "gene 2" ],
      [ "gene 3", "group 1" ]
    ].to_test_file
    
    parser = Parser.new file
    parser.import
    
    parser.lines.should == [ [ "gene 1", "group 1" ],
                             [ "gene 2", ""        ],
                             [ "gene 3", "group 1" ] ]
  end
    
  it "should skip empty lines" do
    file = [
      [ "gene 1", "group 1", "second line will be empty" ],
      [ ],
      [ "gene 2", "group 1" ]
    ].to_test_file
  
    parser = Parser.new file
    parser.import
  
    parser.lines.should == [ [ "gene 1", "group 1" ],
                             [ "gene 2", "group 1" ] ]
  end
    
  it "should set @lines with its results" do
    parser = Parser.new [["a", "b", "c"]].to_test_file
    parser.import
    parser.lines.should == [ [ "a", "b"] ]
  end
  
  it "should remove spaces from the end of genes and groups" do
    parser = Parser.new [[ "gene 1 ", "group 1 "]].to_test_file
    parser.import
    parser.lines.should == [["gene 1","group 1"]]
  end
end

describe "#normalize_groups" do
  it "should turn group column into unique integers per name" do
    file = [
      [ "g1"            ],
      [ "g2", "group 1" ],
      [                 ],
      [ "g3", "group 2" ],
      [ "g4", "group 1" ]
    ].to_test_file
    
    parser = Parser.new(file)
    parser.import.normalize_groups
    
    parser.lines.should == [ [ "g1", 0 ],
                             [ "g2", 1 ],
                             [ "g3", 2 ],
                             [ "g4", 1 ] ]
  end
end

describe "#create_genes" do
  it "should figure out what sort of ID it is, and find that gene" do
    mock_gene_1 = mock "gene 1", :entry_id => "hsa:10"
    mock_gene_2 = mock "gene 2", :ncbi_id => 10000
    mock_gene_3 = mock "gene 3", :ncbi_id => 8675309
    mock_affy = mock "affy", :probe => "stuff_3_at", :genes => [mock_gene_3]
    
    file = [ [mock_gene_1.entry_id, 0],
             [mock_gene_2.ncbi_id, 1],
             [mock_affy.probe, 1] ].to_test_file
   
   parser = Parser.new file
   parser.import.normalize_groups
   
   Gene.should_receive(:find_by_entry_id).with(mock_gene_1.entry_id).and_return mock_gene_1
   Gene.should_receive(:find_by_ncbi_id).with(mock_gene_2.ncbi_id).and_return mock_gene_2
   AffyProbe.should_receive(:find_by_probe).with(mock_affy.probe).and_return mock_affy
   mock_affy.should_receive(:genes).and_return [mock_gene_3]
   
   parser.create_genes
   
   parser.gene_groups.should == [
                                  [mock_gene_1, 0],
                                  [mock_gene_2, 1],
                                  [mock_gene_3, 1]
                                ]
  end
end
end
