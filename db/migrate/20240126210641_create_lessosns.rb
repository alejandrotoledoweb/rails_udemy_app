class CreateLessosns < ActiveRecord::Migration[7.1]
  def change
    create_table :lessosns do |t|
      t.string :title
      t.text :content
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
