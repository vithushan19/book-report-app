require 'json'

questions = QuestionAnswerPair.all

questions.each do |question|
  puts question.question
  puts question.answer
end

puts "Embeddings read #{questions.length} question rows from database"

