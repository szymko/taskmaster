class CreateContext < ActiveRecord::Migration
  def change
    create_table :contexts do |t|
      t.string :name, :null => false
      t.text :details
      t.string :type
      
      t.timestamps
    end
  end
end