require 'json'

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
  req.body = "#{JSON.parse(input_text).to_json}"
end

# Output the response status and body
puts response.status
puts response

puts "Embeddings saved to database"
