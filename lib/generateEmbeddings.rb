require 'openai'
require 'json'

# Set up the OpenAI API key

client = OpenAI::Client.new(access_token: api_key)

# Read the contents of the input file
input_file_path = 'book-input.txt'
input_text = File.read(input_file_path)

chunk_size = 8191
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
embeddings = chunks.map { |chunk| client.embeddings(
    parameters: {
        model: "text-embedding-ada-002",
        input: chunk
    }
) }

# Write embeddings to file
File.open('output.txt', 'w') do |file|
  result = []
  embeddings.each_with_index do |embedding, index|
    result << { "content": "#{chunks[index]}", "embedding": embedding["data"][0]["embedding"]}
  end
  
  file.write(JSON.pretty_generate(result))
end


puts "Embedding saved to output.txt"
