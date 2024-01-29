class AddUserToCourses < ActiveRecord::Migration[7.1]
  def change
    add_reference :courses, :user, null: false, foreign_key: true
  end
end
