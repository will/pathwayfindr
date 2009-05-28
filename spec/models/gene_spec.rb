require File.dirname(__FILE__) + '/../spec_helper'

describe Gene do

  it "should require an entry_id" do
    gene = Gene.new
    gene.should_not be_valid
    gene.entry_id = "an entry id"
    gene.should be_valid
  end
  
  it "should have and belong to many pathways" do
    association = Gene.reflect_on_association :pathways
    association.macro.should equal(:has_and_belongs_to_many)
  end
  
end
