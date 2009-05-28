class Run < ActiveRecord::Base
  has_many :results
  
  def genes
    #TODO: cache this
    genes = {}
    results.each do |result|
      result.genes.each do |gene|
        genes[gene] ||= []
        genes[gene] << result
      end
    end
    genes
  end
  
  def store_groups(g)
    self.groups = Marshal.dump g
  end
  
  def get_groups_and_colors
    return [[]] if self.groups.nil?
    color_groups = []
    Marshal.load(self.groups).each_with_index do |g,i|
      color_groups << [g,Colorizer::Colors[i]]
    end
    color_groups
  end
  
  def filename
    "#{RAILS_ROOT}/tmp/run_#{self.id}"
  end
  
  def file=(incoming_file)
    @temp_file = incoming_file
  end
  
  def job_command
    "ruby \"#{RAILS_ROOT}/script/runner\" \"#{RAILS_ROOT}/jobs/runner.rb\" #{self.id}"
  end
  
  def after_save
    File.open(filename, "w") { |file| file.write @temp_file.read } if @temp_file
  end
  
  def process
    parser = Parser.new filename
    parser.import
    store_groups parser.normalize_groups
    
    parser.create_genes
    parser.gene_groups.reject! {|j| j[0].nil? }
    
    colored_genes = Colorizer::colorize parser.gene_groups
    
    marked_pathways = Processor.new.process colored_genes
    
    self.gene_count    = colored_genes.size
    self.pathway_count = marked_pathways.size
    
    marked_pathways.each do |mp|
      results.create :pathway => mp.pathway,
                     :genes => mp.genes.map(&:gene)
    end
    
    save
  end
  
end
