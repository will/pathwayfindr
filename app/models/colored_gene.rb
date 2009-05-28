class ColoredGene
  attr_accessor :gene, :fg_color, :bg_color
  
  def initialize(options={})
    @gene     = options[:gene]
    @fg_color = options[:fg_color]
    @bg_color = options[:bg_color]
  end
  
  def entry_id
    check_gene
    gene.entry_id
  end
  
  def pathways
    check_gene
    gene.pathways
  end
  
  def fg_color
    check_gene
    @fg_color
  end
  
  def bg_color
    check_gene
    @bg_color
  end
  
  def check_gene
    raise "No gene set" unless gene
  end
end