require 'test_helper'

class BookQuestionTest < ActiveSupport::TestCase
  # Test the validations for the BookQuestion model
  test 'should not save book question without question' do
    book_question = BookQuestion.new(answer: 'Some answer')
    assert_not book_question.save, 'Saved the book question without a question'
  end

  test 'should not save book question without answer' do
    book_question = BookQuestion.new(question: 'Some question')
    assert_not book_question.save, 'Saved the book question without a answer'
  end

end
