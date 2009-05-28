class Pathway < ActiveRecord::Base
  has_and_belongs_to_many :genes
  belongs_to :species
  
  validates_presence_of :definition, :entry_id, :species
end
