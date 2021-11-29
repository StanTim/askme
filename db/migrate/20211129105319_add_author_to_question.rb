class AddAuthorToQuestion < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :author, :string
  end
end
