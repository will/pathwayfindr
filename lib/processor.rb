class Processor
  attr_accessor :colored_genes, :marked_pathways
  
  def initialize
    @marked_pathways = []
  end
  
  def find_marked_pathway(pathway)
    marked = @marked_pathways.find { |mp| mp.pathway_id == pathway.entry_id }
    if marked.nil?
      marked = MarkedPathway.new :pathway => pathway
      @marked_pathways << marked
    end
    marked
  end
  
  def process(colored_genes = [])
    colored_genes.each do |colored_gene|
      colored_gene.pathways.each do |pathway|
        marked = find_marked_pathway pathway
        marked.genes << colored_gene
      end
    end
    @marked_pathways
  end
  
  
end