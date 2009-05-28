require File.dirname(__FILE__) + '/../spec_helper'

describe KeggImporter do
  before(:each) do
    @mock_api = mock "kegg api"
    Bio::KEGG::API.stub!(:new).and_return @mock_api
    @kegg = KeggImporter.new
  end



describe "#get_pathways_for(species)" do
  before(:each) do
    @kegg.stub!(:get_genes_for)
    @m_path1 = mock "pathway 1", :definition => "Jak-STAT",      :entry_id => "entry 1"
    @m_path2 = mock "pathway 2", :definition => "other pathway", :entry_id => "entry 2"
    @m_path3 = mock "pathway 3", :definition => "jak-stat",      :entry_id => "entry 3"
    @mock_species = mock_model Species, :entry_id => "hsa"
  end

  it "should ensure there is a connection" do
    @mock_api.stub!(:list_pathways).and_return [@m_path1]
    Bio::KEGG::API.should_receive(:new).and_return @mock_api
    @kegg.get_pathways_for @mock_species
  end
  
  it "should ask KEGG for all pathways for the species" do
    Pathway.stub! :create
    @mock_api.should_receive(:list_pathways).with(@mock_species.entry_id).and_return [ @m_path1, @m_path2, @m_path3 ]
    @kegg.get_pathways_for @mock_species
  end

  it "should save build and save a Pathway model for each matching pathway and put them in @pathways" do
    @mock_api.stub!(:list_pathways).and_return [@m_path1, @m_path3]
    
    Pathway.should_receive(:create).with( :definition => @m_path1.definition,
                                          :entry_id   => @m_path1.entry_id,
                                          :species    => @mock_species
                                        ).and_return @m_path1
    Pathway.should_receive(:create).with( :definition => @m_path3.definition,
                                          :entry_id   => @m_path3.entry_id,
                                          :species    => @mock_species
                                        ).and_return @m_path3
    
    @kegg.get_pathways_for @mock_species
    
    @kegg.pathways.should include(@m_path1, @m_path3)
    @kegg.pathways.should_not include(@m_path2)
  end
  
  it "should get genes for each pathway" do
    @mock_api.stub!(:list_pathways).and_return [@m_path1, @m_path3]
    @kegg.should_receive(:get_genes_for).twice
    @kegg.get_pathways_for @mock_species
  end
end

describe "#get_genes_for(pathway)" do
  before(:each) do
    @mock_pathway = mock "mock pathway", :entry_id => "entry id"
  end

  it "should take one argument" do
    lambda { @kegg.get_genes_for                              }.should     raise_error(ArgumentError)
    lambda { @kegg.get_genes_for @mock_pathway                }.should_not raise_error(ArgumentError)
    lambda { @kegg.get_genes_for @mock_pathway, @mock_pathway }.should     raise_error(ArgumentError)
  end
  
  it "should ensure there is a connection" do
    @mock_api.stub!(:get_genes_by_pathway)
    Bio::KEGG::API.should_receive(:new).and_return @mock_api
    @kegg.get_genes_for @mock_pathway
  end
  
  it "should ask KEGG for the genes for the pathway" do
    @mock_api.should_receive(:get_genes_by_pathway).with(@mock_pathway.entry_id)
    @kegg.get_genes_for @mock_pathway
  end
  
  it "should go through all genes from the pathway, updating or creating as necessary" do
    @mock_gene1 = mock "gene 1"
    @mock_gene2 = mock "gene 2"
    @mock_api.stub!(:get_genes_by_pathway).and_return [@mock_gene1, @mock_gene2]
    
    @kegg.should_receive(:create_or_update_gene).with(@mock_gene1, @mock_pathway)
    @kegg.should_receive(:create_or_update_gene).with(@mock_gene2, @mock_pathway)
    
    @kegg.get_genes_for @mock_pathway
  end
end

describe "#create_or_update_gene(entry_id, pathway)" do
  before(:each) do
    @pathway = Pathway.create(:definition => "def", :entry_id => "entry id", :species => mock_model(Species))
    @entry_id = "mock gene"
  end
  
  it "should take 2 arguments" do
    lambda { @kegg.create_or_update_gene                     }.should     raise_error(ArgumentError)
    lambda { @kegg.create_or_update_gene @entry_id           }.should     raise_error(ArgumentError)
    lambda { @kegg.create_or_update_gene @entry_id, @pathway }.should_not raise_error(ArgumentError)
  end
  
  it "should check if gene exists" do
    Gene.should_receive(:find_by_entry_id).with(@entry_id)
    
    @kegg.create_or_update_gene(@entry_id, @pathway)
  end
  
  it "should update gene pathway association when gene exists" do
    gene = Gene.create(:entry_id => "gene entry")
    Gene.stub!(:find_by_entry_id).and_return gene
    
    @pathway.genes.should be_empty
    #save
    @kegg.create_or_update_gene(@entry_id, @pathway)
    @pathway.reload
    @pathway.genes.should == [gene]
  end
  
  it "should create a new gene and add it to the pathway when the gene does not exist" do
    Gene.stub!(:find_by_entry_id).and_return nil
    Gene.find_by_entry_id(@entry_id).should be_nil
    @pathway.genes.should be_empty
    
    @kegg.create_or_update_gene(@entry_id, @pathway)
     
    @pathway.genes.should_not be_empty 
  end
end

describe "#update" do
  before(:each) do
    @kegg.stub! :clear
    @kegg.stub! :create_species
    @kegg.stub! :get_pathways_for
    @kegg.stub! :get_ncbi_ids_for
    @kegg.stub! :add_affy_probesets
  end

  it "should call #clear" do
    @kegg.should_receive :clear
    @kegg.update
  end

  it "should call #create_species" do
    @kegg.should_receive :create_species
    @kegg.update
  end

  it "should get the pathways for each species" do
    mock_species1 = mock_model Species
    mock_species2 = mock_model Species
    Species.should_receive(:find).with(:all).and_return [mock_species1, mock_species2]
    
    @kegg.should_receive(:get_pathways_for).with(mock_species1)
    @kegg.should_receive(:get_pathways_for).with(mock_species2)
    
    @kegg.update
  end
end

describe "#clear" do
  it "should delete all species, pathways, and genes" do
    Species.should_receive :delete_all
    Pathway.should_receive :delete_all
    Gene.should_receive    :delete_all
    
    @kegg.clear
  end
end

describe "#create_species" do
  it "should ensure there is a connection" do
   Bio::KEGG::API.should_receive(:new).and_return @mock_api
   @mock_api.stub!(:list_organisms).and_return []
   @kegg.create_species
  end
  
  it "should create species for each from KEGG and the generic species" do
    ms1 = mock('mock human', {:entry_id => "hsa", :definition => "human"})
    ms2 = mock('mock chimp', {:entry_id => "ptr", :definition => "chimp"})
    ms3 = mock('mock other', {:entry_id => "lol", :definition => "lolol"})
    @mock_api.should_receive(:list_organisms).and_return [ ms1, ms2, ms3 ]
    
    Species.should_receive(:create).with(:entry_id => ms1.entry_id, :definition => ms1.definition)
    Species.should_receive(:create).with(:entry_id => ms2.entry_id, :definition => ms2.definition)
    Species.should_not_receive(:create).with(:entry_id => ms3.entry_id, :definition => ms3.definition)
    Species.should_receive(:create).with(:entry_id => "ko", :definition => "Generic")
    
    @kegg.create_species
  end
end

describe "#get_ncbi_ids_for" do
  it "should skip if the species is the reference species" do
    mock_species = mock "species", :entry_id => "ko"
    KeggImporter.new.get_ncbi_ids_for(mock_species).should be_nil
  end
  
  it "should parse the file correctly, find each gene, set the new ncbi_id, and save" do
    number  = 10000
    kegg_id, ncbi_id = "hsa:#{number}", "ncbi-geneid:#{number}"
    
    mock_file = mock "file"
    mock_file.should_receive(:each_line).and_yield "#{kegg_id}\t#{ncbi_id}"
    OpenURI.should_receive(:open_uri).and_yield mock_file
    mock_gene = mock "gene", :entry_id => kegg_id, :ncbi_id => nil
    
    Gene.should_receive(:find_by_entry_id).with(kegg_id).and_return mock_gene
    mock_gene.should_receive(:ncbi_id=).with number
    mock_gene.should_receive :save
    
    mock_species = mock "species", :entry_id => "hsfa"
    KeggImporter.new.get_ncbi_ids_for mock_species
  end
end

describe "#add_affy_probesets" do
  before(:each) do
    file = [["probe_at", 3]].to_test_file
    Dir.stub!(:glob).and_return [file]
  end
  it "should save a new AffyProbe and add it to the Gene if the gene exists and the probe isn't already there" do
    mock_gene = mock "gene", :affy_probes => []
    
    Gene.should_receive(:find_by_ncbi_id).with(3).and_return mock_gene
    AffyProbe.should_receive(:find_by_probe).with("probe_at").and_return nil
    
    
    AffyProbe.should_receive(:create).with(:probe => "probe_at")
    mock_gene.should_receive(:save)
    
    KeggImporter.new.add_affy_probesets
  end
end

describe "#connect" do
  it "should make a new connection, only once" do
    Bio::KEGG::API.should_receive(:new).once.and_return @mock_api
    kegg = KeggImporter.new
    kegg.connect
    kegg.connect
    kegg.connection.should == @mock_api
  end
end

end
