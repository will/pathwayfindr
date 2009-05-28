class Species < ActiveRecord::Base
  has_many :pathways
  
  validates_presence_of :definition, :entry_id
end
