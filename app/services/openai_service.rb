require 'openai'
require 'dotenv/load'

class OpenaiService
    # Set up the OpenAI API key
    api_key = ENV['OPENAI_API_KEY']    

    @@client = OpenAI::Client.new(access_token: api_key)

    def self.fetch_embeddings_for_book(book_title, input_text)
        section_size = 1950
        overlap = 20

        # Split text into sections
        sections = []
        start = 0
        while start < input_text.length
            section = input_text[start, section_size]
            sections << section
            start += section_size - overlap
        end
        puts "Calling OpenAI API to get embeddings for sections of #{book_title}"
        puts "Each section has #{section_size} characters"
        puts "The overlap between sections is #{overlap} characters"
        puts "Total number of characters is #{input_text.length}"
        puts "Total number of sections is #{sections.length}"

        # Fetch embeddings for each chunk
        result = sections.map.with_index { |section, index| 
            
            embedding = @@client.embeddings(
            parameters: {
                model: "text-embedding-ada-002",
                input: section
            })

            { "title": book_title, "content": section, "embeddings": embedding["data"][0]["embedding"]}
         }


        return {data: result}
    end

    def self.get_answer_from_open_ai(title, question)
        # Fetch embedding vector for question
        question_embedding = OpenaiService::fetch_embedding_for_question(question)[:embedding]
        
        # Get all book sections from the database for the current book 
        book_sections = BookSection.where(title: title)

        # Calculate the cosine similarity between the question's embedding vector and each book section's embedding vector
        book_sections_with_similarities = book_sections.map { |book_section|
            book_section_hash = book_section.attributes

            similarity = OpenaiService::cosine_similarity(book_section.embeddings, question_embedding)
            book_section_hash["similarity"] = similarity
            book_section_hash
        }

        # Sort the array of hashes by the 'similarity' attribute in descending order
        sections_sorted_by_semantic_relevance = book_sections_with_similarities.sort_by { |item| item["similarity"] }.reverse

        # Create a prompt using the top 3 most semantically relevant sections
        prompt = "The following are relvant sections from a book called #{title} 
        
        #{sections_sorted_by_semantic_relevance[0]["content"]} 
        #{sections_sorted_by_semantic_relevance[1]["content"]} 
        #{sections_sorted_by_semantic_relevance[3]["content"]} 
        
        Here is a question about the book #{title} and the relevant sections. 
        
        Question: #{question} 
        
        Provide a detailed answer to the question. 
        
        If you do not know the answer then says 'I don't know the answer given the information from the book'"

        answer = OpenaiService::fetch_completion_for_prompt(prompt) # Fetch completion using OpenAI service

        return answer
    end
    
    private

    def self.fetch_embedding_for_question(text)
        puts "Calling OpenAI API to get embeddings for question: #{text}"

        embedding = @@client.embeddings(
            parameters: {
                model: "text-embedding-ada-002",
                input: text
            }
        )
        { "question": text, "embedding": embedding["data"][0]["embedding"]}
    end

    def self.fetch_completion_for_prompt(prompt)
        puts "Calling OpenAI API to get completion for prompt: #{prompt}"

        response = @@client.completions(
            parameters: {
                model: "text-davinci-003",
                prompt: prompt,
                max_tokens: 50
            })
        response["choices"][0]["text"].strip
    end

    def self.cosine_similarity(array1, array2)
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
  end
  