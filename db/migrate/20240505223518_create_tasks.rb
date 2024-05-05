class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :author
      t.string :assigned
      t.date :expired
      t.integer :priority

      t.timestamps
    end
  end
end
