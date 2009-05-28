SPECIES = %w[ko hsa ptr mcc mmu rno cfa bta ssc mdo dme]
MATCH_PATHWAYS = /two-component|mapk|erbb|wnt|notch|hedgehog|tgf-beta|vegf|jak-stat|calcium|phosphatidylinositol signaling|mtor/i

class KeggImporter
  attr :connection
  attr_reader :pathways
  
  def connect
    @connection ||= Bio::KEGG::API.new
  end
  
  def update
    # puts "clearing old information"
    clear
    # puts "starting import..."
    create_species
    Species.find(:all).each do |species|
      p species
      get_pathways_for species
      get_ncbi_ids_for species
    end
    add_affy_probesets
  end
  
  def clear
    Species.delete_all
    Pathway.delete_all
    Gene.delete_all
  end
  
  def create_species
    connect
    species = connection.list_organisms.select { |s| SPECIES.include? s.entry_id }
    species.each { |s| Species.create :entry_id => s.entry_id, :definition => s.definition }
    Species.create :entry_id => "ko", :definition => "Generic"
  end
  
  def get_pathways_for(species)
    connect
    
    pathways = @connection.list_pathways(species.entry_id).select { |p| p.definition =~ MATCH_PATHWAYS }
    
    @pathways = []
    pathways.each do |p|
      @pathways << Pathway.create(:definition => p.definition, :entry_id => p.entry_id, :species => species)
    end if pathways
    
    @pathways.each {|path| get_genes_for path}
    # puts "added all pathways for #{species.definition}"
  end
  
  def get_genes_for(pathway)
    connect
    genes = @connection.get_genes_by_pathway pathway.entry_id
    genes.each do |gene|
      create_or_update_gene gene, pathway
    end if genes
  end
  
  def create_or_update_gene(entry_id, pathway)
    gene = Gene.find_by_entry_id(entry_id)
    if gene
      gene.pathways << pathway
      gene.save
    else
      pathway.genes.build(:entry_id => entry_id)
      pathway.save
    end
  end
  
  def get_ncbi_ids_for(species)
    # puts "storing ncbi translation for #{species.definition}"
    return if species.entry_id == "ko" # doesn't work for generic pathway
    url = "ftp://ftp.genome.jp/pub/kegg/genes/organisms/#{species.entry_id}/#{species.entry_id}_ncbi-geneid.list"
    OpenURI.open_uri(url) do |file|
      file.each_line do |line|
        kegg_id, ncbi = line.split "\t"
        
        gene = Gene.find_by_entry_id(kegg_id)
        if gene
          gene.ncbi_id = ncbi.scan(/(\d+)/).to_s.to_i
          gene.save
        end
      end
    end
  end
  
  def add_affy_probesets
    files = Dir.glob("#{RAILS_ROOT}/data/*.affy")
    files.each do |file|
      File.open(file).each_line do |line|
        affy_probe, ncbi_list = line.split "\t"
        next if ncbi_list =~ /---/
        next if ncbi_list.nil?
        ncbi_ids = ncbi_list.split " /// "
        genes = ncbi_ids.inject [] do |acc, ncbi_id|
          gene = Gene.find_by_ncbi_id ncbi_id.to_i
          acc << gene if gene
          acc
        end
        
        unless genes.empty?
          affy = AffyProbe.find_by_probe(affy_probe) || AffyProbe.create(:probe => affy_probe)
          genes.each do |gene|
            unless gene.affy_probes.include? affy
              gene.affy_probes << affy
              gene.save
            end
          end
        end
      end
    end
  end
end
