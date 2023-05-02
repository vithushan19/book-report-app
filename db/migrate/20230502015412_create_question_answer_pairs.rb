class CreateQuestionAnswerPairs < ActiveRecord::Migration[7.0]
  def change
    create_table :question_answer_pairs do |t|
      t.string :question
      t.string :answer

      t.timestamps
    end
  end
end
