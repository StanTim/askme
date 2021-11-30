class AddHeaderColorToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :color, :string, default: "#005a55"
  end
end
