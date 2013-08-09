class CreatePageScrappingContextRelation < ActiveRecord::Migration
  def change
    create_table :page_scrapping_context_relations do |t|
      t.belongs_to :page, :null => false
      t.belongs_to :scrapping_context, :null => false

      t.timestamps
    end

    add_index :page_scrapping_context_relations, :page_id
    add_index :page_scrapping_context_relations, :scrapping_context_id
    add_index :page_scrapping_context_relations, [:page_id, :scrapping_context_id], :unique => true, :name => "page_scrapping_context_index"
  end
end