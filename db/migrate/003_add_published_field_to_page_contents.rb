class AddPublishedFieldToPageContents < ActiveRecord::Migration
  def change
    change_table :page_contents do |t|
      t.boolean :published, default: false
    end

    add_index :page_contents, :published
  end
end
