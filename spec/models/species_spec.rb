require File.dirname(__FILE__) + '/../spec_helper'

describe Species do
  before(:each) do
    @species = Species.new(:entry_id => "what", :definition => "lol")
  end
  
  it "should have many pathways" do
    association = Species.reflect_on_association :pathways
    association.macro.should equal(:has_many)
  end
  
  it "should require a definition" do
    @species.definition = nil
    @species.should_not be_valid
    @species.definition = "a definition"
    @species.should be_valid
  end
  
  it "should require an entry_id" do
    @species.entry_id = nil
    @species.should_not be_valid
    @species.entry_id = "an entry id"
    @species.should be_valid
  end
  
end
