class Parser
  attr_accessor :filename, :lines, :gene_groups
  
  def initialize(filename)
    @filename = filename
    @lines = ""
    @gene_groups = []
  end
  
  def import
    lines = [ ]
    File.new(@filename).readlines.each do |line|
      chunks = line.split "\t"
      first  = chunks[0].try(:strip)
      second = chunks[1].try(:strip) || ""
      lines << [ first, second ] unless first.empty?
    end
    @lines = lines
    self
  end

  def normalize_groups
    memory = []
    @lines.each do |line|
      memory << line[1] unless memory.include? line[1]
      line[1] = memory.index line[1]
    end
    memory
  end
  
  def create_genes
    lines.each do |line|
      id = line.first
      group = line.last
      if id =~ /^[a-z]{3}:.+$/
        gene = Gene.find_by_entry_id id
        gene_groups << [gene, group] if gene
      elsif id =~ /^\d+$/
        gene = Gene.find_by_ncbi_id id.to_i
        gene_groups << [gene, group] if gene
      elsif id =~ /(_at|_st)$/
        genes = AffyProbe.find_by_probe(id).try(:genes)
        genes.each do |gene|
          gene_groups << [gene, group]
        end if genes
      end
    end
  end
end
