class AddPublishedAndApprovedToCourse < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :published, :boolean
    add_column :courses, :approved, :boolean
  end
end
