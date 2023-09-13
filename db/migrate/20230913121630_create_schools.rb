class CreateSchools < ActiveRecord::Migration[7.0]
  def change
    create_table :schools do |t|
      t.string :name, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
