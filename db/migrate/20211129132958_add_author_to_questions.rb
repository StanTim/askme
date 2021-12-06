class AddAuthorToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :author, :integer

    add_reference :questions, :author
  end
end
