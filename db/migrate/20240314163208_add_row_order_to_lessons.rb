class AddRowOrderToLessons < ActiveRecord::Migration[7.1]
  def change
    add_column :lessons, :row_order, :integer
  end
end
