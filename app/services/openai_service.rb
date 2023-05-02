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
        result = chunks.map.with_index { |chunk, index| 
            
            embedding = @@client.embeddings(
            parameters: {
                model: "text-embedding-ada-002",
                input: chunk
            })

            { "title": book_title, "content": chunk, "embeddings": embedding["data"][0]["embedding"]}
         }


        return {data: result}
    end

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
                model: "text-davinci-001",
                prompt: prompt,
                max_tokens: 50
            })
        response["choices"][0]["text"].strip
    end
  end
  