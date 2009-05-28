class MarkedPathway
  
  attr_accessor :pathway, :genes
  
  def initialize(options={})
    @pathway = options[:pathway]
    @genes   = options[:genes] || []
  end
  
  def pathway_id
    @pathway.try(:entry_id)
  end
  
  def gene_list
    @genes.andand.inject([]) { |acc, gene| acc << gene.entry_id }
  end
  
  def bg_colors
    @genes.andand.inject([]) { |acc, gene| acc << gene.bg_color }
  end
  
  def fg_colors
    @genes.andand.inject([]) { |acc, gene| acc << gene.fg_color }
  end
  
  def get_image_url
    serv = Bio::KEGG::API.new
    serv.color_pathway_by_objects pathway_id, gene_list, fg_colors, bg_colors
  end
  
end
