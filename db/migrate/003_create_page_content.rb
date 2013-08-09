class CreatePageContent < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.text :headers
      t.text :body, :null => false
      t.string :status_code, :null => false
      t.belongs_to :page, :null => false
      t.belongs_to :scrapping_context

      t.timestamps
    end

    add_index :page_contents, :page_id
    add_index :page_contents, :scrapping_context_id
  end
end