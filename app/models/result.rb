class Result < ActiveRecord::Base
  belongs_to :run
  belongs_to :pathway
  has_and_belongs_to_many :genes
end
