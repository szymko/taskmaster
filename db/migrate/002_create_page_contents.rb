class CreatePageContents < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.text :headers
      t.text :body, :null => false
      t.string :status_code, :null => false
      t.belongs_to :page, :null => false

      t.timestamps
    end

    add_index :page_contents, :page_id
  end
end
