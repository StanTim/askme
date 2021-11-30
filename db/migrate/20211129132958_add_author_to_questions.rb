class AddAuthorToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :author, :integer
    add_index :questions, :author_id

    add_reference :questions, :author
  end
end
