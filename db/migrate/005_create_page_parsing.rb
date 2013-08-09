class CreatePageParsing < ActiveRecord::Migration
  def change
    create_table :page_parsings do |t|
      t.text :document, :null => false
      t.belongs_to :page, :null => false
      t.belongs_to :parsing_context

      t.timestamps
    end

    add_index :page_parsings, :page_id
    add_index :page_parsings, :parsing_context_id
  end
end