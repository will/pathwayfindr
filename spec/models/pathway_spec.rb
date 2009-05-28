require File.dirname(__FILE__) + '/../spec_helper'

describe Pathway do
  before(:each) do
    @mock_species = mock_model Species
    @pathway = Pathway.new(:definition => "a definition", :entry_id => "an entry id", :species => @mock_species)
  end
  
  it "should have and belong to many genes" do
    association = Pathway.reflect_on_association :genes
    association.macro.should equal(:has_and_belongs_to_many)
  end
  
  it "should belong to species" do
    association = Pathway.reflect_on_association :species
    association.macro.should equal(:belongs_to)
  end
  
  it "should require a definition" do
    @pathway.definition = nil
    @pathway.should_not be_valid
    @pathway.definition = "a definition"
    @pathway.should be_valid
  end
  
  it "should require an entry_id" do
    @pathway.entry_id = nil
    @pathway.should_not be_valid
    @pathway.entry_id = "an entry id"
    @pathway.should be_valid
  end
  
  it "should require a species" do
    @pathway.species = nil
    @pathway.should_not be_valid
    @pathway.species = @mock_species
    @pathway.should be_valid
  end
end
