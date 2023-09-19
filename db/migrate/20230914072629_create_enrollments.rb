class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.bigint :student_id, null: false
      t.bigint :batch_id, null: false
      t.bigint :school_id, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
