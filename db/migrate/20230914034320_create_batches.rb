class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.string :name, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.text :description
      t.belongs_to :course

      t.timestamps
    end
  end
end
