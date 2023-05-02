require 'json'

class HomepageController < ApplicationController
  skip_forgery_protection

  def index
  end

  def get_recent_questions
    book_title = params[:book]

    # Get the most recent 10 questions for the specified book
    book_questions = BookQuestion.where(book_title: book_title).order(created_at: :desc).limit(10)

    # Return the questions
    render json: { message: "Success", data: book_questions}
  end

  def search
    question = params[:question]
    book_title = params[:book]
    
    # Use the find_by method to search for the question-answer pair by question
    book_question = BookQuestion.find_by(question: question.downcase.strip)

    # Check if a matching pair was found
    if book_question
      # Output the question and answer
      puts "Answer found in cache for the specified question."

      puts "Book Title: #{book_question.book_title}"
      puts "Question: #{book_question.question}"
      puts "Answer: #{book_question.answer}"
      answer = book_question.answer
    else
      # Output a message if no matching pair was found
      puts "No answer found in cache for the specified question."
      answer = getAnswerFromOpenAI(book_title, question)

      if answer == nil || answer == "" || answer == " " 
        puts "No answer found in OpenAI for the specified question. Try asking a different question."
      else
        BookQuestion.create!(book_title: book_title, question: question.downcase.strip, answer: answer)
      end
    end
    
    render json: { message: "Success", data: answer}

  end

end
