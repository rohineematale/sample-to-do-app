class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.date :due_date
      t.integer :user_id
      t.string :status, default: 'pending'
      t.float :sequence
      t.timestamps
    end
  end
end
