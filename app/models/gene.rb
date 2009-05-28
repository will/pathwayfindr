class Gene < ActiveRecord::Base
  has_and_belongs_to_many :pathways
  has_and_belongs_to_many :affy_probes
  
  validates_presence_of :entry_id
end
