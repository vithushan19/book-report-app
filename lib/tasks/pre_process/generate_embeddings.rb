require 'json'

# Arguments
book_title = "Palace of Illusions"
input_file_path = 'book-input.txt'

# Read the contents of the input file
input_text = File.read(input_file_path)

result = OpenaiService::fetch_embeddings_for_book(book_title, input_text)

# Write embeddings to file
File.open('output.txt', 'w') do |file|
  file.write(JSON.pretty_generate(result[:data]))
end
puts "Embedding saved to output.txt"


# Insert multiple book sections into the database
BookSection.create(result[:data])
puts "Embedding saved to database"
