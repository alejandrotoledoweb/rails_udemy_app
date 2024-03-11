class AddPublishedAndApprovedToCourse < ActiveRecord::Migration[7.1]
  def change
    add_column :courses, :published, :boolean, default: false
    add_column :courses, :approved, :boolean, default: false
  end
end
