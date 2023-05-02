require 'json'

class HomepageController < ApplicationController
  skip_forgery_protection

  def index
  end

  def cosine_similarity(array1, array2)
    # Check if the arrays have the same length
    if array1.length != array2.length
      raise ArgumentError, "The arrays must have the same length"
    end
  
    # Calculate the dot product and magnitudes
    dot_product = 0.0
    magnitude1 = 0.0
    magnitude2 = 0.0
    array1.each_with_index do |value1, index|
      value2 = array2[index]
      dot_product += value1 * value2
      magnitude1 += value1 ** 2
      magnitude2 += value2 ** 2
    end
  
    # Calculate the cosine similarity
    magnitude1 = Math.sqrt(magnitude1)
    magnitude2 = Math.sqrt(magnitude2)
    cosine_similarity = dot_product / (magnitude1 * magnitude2)
  
    cosine_similarity
  end

  def getAnswerFromOpenAI(title, question)
    question_embedding = OpenaiService.fetch_embedding_for_question(question)[:embedding] # Fetch embeddings using OpenAI service
    book_sections = BookSection.select('*')

    # Calculate the cosine similarity between the query and each book section
    book_sections_with_similarities = book_sections.map { |book_section|
      book_section_hash = book_section.attributes

      similarity = cosine_similarity(book_section.embeddings, question_embedding)
      book_section_hash["similarity"] = similarity
      book_section_hash
    }

    # Sort the array of hashes by the 'value' attribute in descending order
    sections_sorted_by_semantic_relevance = book_sections_with_similarities.sort_by { |item| item["content"] }.reverse

    # Create a prompt using the top 2 most semantically relevant sections
    prompt = "Here are relvant sections from a book called #{title} 
    
    #{sections_sorted_by_semantic_relevance[0]["content"]} 
    #{sections_sorted_by_semantic_relevance[1]["content"]} 
    
    Here is a question about the book #{title}. 
    
    Question: #{question} 
    
    Provide a detailed answer to the question. 
    
    If you do not know the answer then says 'I don't know the answer given the information from the book'"

    answer = OpenaiService.fetch_completion_for_prompt(prompt) # Fetch completion using OpenAI service

    puts "prompt"
    puts prompt
    puts "answer"
    puts answer
    return answer
  end

  def getRecentQuestions
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
    book_question = BookQuestion.find_by(question: question)

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
        BookQuestion.create(book_title: book_title, question: question, answer: answer)
      end
    end
    
    render json: { message: "Success", data: answer}

  end

end
