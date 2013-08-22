class CreateRobot < ActiveRecord::Migration
  def change
    create_table :robots do |t|
      t.string :host, null: false
      t.text :rules

      t.timestamps
    end

    add_index :robots, :host, unique: true
  end
end