class AddBookTitleToQuestionAnswerPairsAndRenameTable < ActiveRecord::Migration[7.0]
  def change
   # Add the book_title column to the question_answer_pairs table
   add_column :question_answer_pairs, :book_title, :string

   # Rename the question_answer_pairs table to book_questions
   rename_table :question_answer_pairs, :book_questions
 end
end
