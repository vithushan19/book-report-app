require 'openai'

class OpenaiService
    # Set up the OpenAI API key

    @@client = OpenAI::Client.new(access_token: api_key)

    def self.fetch_embeddings_for_book(book_title, input_text)
      
        chunk_size = 1950
        overlap = 20

        # Split text into chunks
        chunks = []
        start = 0
        while start < input_text.length
            chunk = input_text[start, chunk_size]
            chunks << chunk
            start += chunk_size - overlap
        end

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
        embedding = @@client.embeddings(
            parameters: {
                model: "text-embedding-ada-002",
                input: text
            }
        )
        { "question": text, "embedding": embedding["data"][0]["embedding"]}
    end

    def self.fetch_completion_for_prompt(prompt)
        response = @@client.completions(
            parameters: {
                model: "text-davinci-001",
                prompt: prompt,
                max_tokens: 50
            })
        response["choices"][0]["text"]
    end
  end
  