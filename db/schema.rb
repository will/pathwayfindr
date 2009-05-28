# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 17) do

  create_table "affy_probes", :force => true do |t|
    t.string   "probe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "affy_probes", ["probe"], :name => "index_affy_probes_on_probe"

  create_table "affy_probes_genes", :id => false, :force => true do |t|
    t.integer "affy_probe_id"
    t.integer "gene_id"
  end

  add_index "affy_probes_genes", ["gene_id"], :name => "index_affy_probes_genes_on_gene_id"
  add_index "affy_probes_genes", ["affy_probe_id"], :name => "index_affy_probes_genes_on_affy_probe_id"

  create_table "bj_config", :id => false, :force => true do |t|
    t.integer "bj_config_id", :null => false
    t.text    "hostname"
    t.text    "key"
    t.text    "value"
    t.text    "cast"
  end

  add_index "bj_config", ["hostname", "key"], :name => "index_bj_config_on_hostname_and_key", :unique => true

  create_table "bj_job", :id => false, :force => true do |t|
    t.integer  "bj_job_id",      :null => false
    t.text     "command"
    t.text     "state"
    t.integer  "priority"
    t.text     "tag"
    t.integer  "is_restartable"
    t.text     "submitter"
    t.text     "runner"
    t.integer  "pid"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text     "env"
    t.text     "stdin"
    t.text     "stdout"
    t.text     "stderr"
    t.integer  "exit_status"
  end

  create_table "bj_job_archive", :id => false, :force => true do |t|
    t.integer  "bj_job_archive_id", :null => false
    t.text     "command"
    t.text     "state"
    t.integer  "priority"
    t.text     "tag"
    t.integer  "is_restartable"
    t.text     "submitter"
    t.text     "runner"
    t.integer  "pid"
    t.datetime "submitted_at"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "archived_at"
    t.text     "env"
    t.text     "stdin"
    t.text     "stdout"
    t.text     "stderr"
    t.integer  "exit_status"
  end

  create_table "genes", :force => true do |t|
    t.string   "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ncbi_id"
  end

  add_index "genes", ["ncbi_id"], :name => "index_genes_on_ncbi_id"
  add_index "genes", ["entry_id"], :name => "index_genes_on_entry_id"

  create_table "genes_pathways", :id => false, :force => true do |t|
    t.integer "gene_id"
    t.integer "pathway_id"
  end

  add_index "genes_pathways", ["pathway_id"], :name => "index_genes_pathways_on_pathway_id"
  add_index "genes_pathways", ["gene_id"], :name => "index_genes_pathways_on_gene_id"

  create_table "genes_results", :id => false, :force => true do |t|
    t.integer "gene_id"
    t.integer "result_id"
  end

  add_index "genes_results", ["result_id"], :name => "index_genes_results_on_result_id"
  add_index "genes_results", ["gene_id"], :name => "index_genes_results_on_gene_id"

  create_table "pathways", :force => true do |t|
    t.string   "definition"
    t.string   "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "species_id"
  end

  add_index "pathways", ["species_id"], :name => "index_pathways_on_species_id"
  add_index "pathways", ["entry_id"], :name => "index_pathways_on_entry_id"

  create_table "results", :force => true do |t|
    t.string   "url"
    t.integer  "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pathway_id"
  end

  create_table "runs", :force => true do |t|
    t.string   "filename"
    t.float    "percent_done"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "groups"
    t.integer  "gene_count"
    t.integer  "pathway_count"
  end

  create_table "species", :force => true do |t|
    t.string   "definition"
    t.string   "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "species", ["entry_id"], :name => "index_species_on_entry_id"

end
