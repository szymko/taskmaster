class CreatePage < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url, :null => false
      t.string :status

      t.timestamps
    end
  end
end