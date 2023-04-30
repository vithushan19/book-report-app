

# Read the contents of the input file
input_file_path = 'output.txt'
input_text = File.read(input_file_path)


conn = Faraday.new(
  url: "#{SUPBASE_URL}",
  headers: {
    'Content-Type' => 'application/json', 
    'Authorization' => "Bearer #{SUPABASE_KEY}", 
    'apikey' => "#{SUPABASE_KEY}"}
)

response = conn.post("#{SUPBASE_URL}") do |req|
  req.body = {content: 'chunky bacon', embedding: [1.0, 1.5, -1.8]}.to_json
end

# Output the response status and body
puts response.status
puts response.body
puts "Embeddings saved to database"
