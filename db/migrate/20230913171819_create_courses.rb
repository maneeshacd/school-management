class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.text :description
      t.integer :years, null: false
      t.belongs_to :school

      t.timestamps
    end
  end
end
