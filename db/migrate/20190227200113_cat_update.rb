class CatUpdate < ActiveRecord::Migration[5.2]
  def change
    drop_table :cats
    create_table :cats do |t|
      t.date :birth_date, null: false
      t.string :color, null: false
      t.string :name, null: false
      t.string :sex, null: false
      t.text :description
      t.integer :owner_id, null: false

      t.timestamps
    end
    add_index :cats, :owner_id
    add_index :cats, :name
  end
end
