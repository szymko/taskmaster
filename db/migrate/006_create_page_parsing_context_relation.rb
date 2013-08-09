class CreatePageParsingContextRelation < ActiveRecord::Migration
  def change
    create_table :page_parsing_context_relations do |t|
      t.belongs_to :page, :null => false
      t.belongs_to :parsing_context, :null => false

      t.timestamps
    end

    add_index :page_parsing_context_relations, :page_id
    add_index :page_parsing_context_relations, :parsing_context_id
    add_index :page_parsing_context_relations, [:page_id, :parsing_context_id], :unique => true, :name => "page_parsing_context_index"
  end
end