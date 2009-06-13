desc "start import from kegg"
task :import => :environment do
  KeggImporter.new.update
end