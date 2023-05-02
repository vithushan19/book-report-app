require 'pdf-reader'

# Define the path to the PDF file
pdf_file_path = 'books/palace-of-illusions.pdf'

# Initialize an empty string to store the extracted text
extracted_text = ''

# Open the PDF file and extract the text from each page
PDF::Reader.open(pdf_file_path) do |reader|
  reader.pages.each do |page|
    extracted_text += page.text
  end
end

# Output the extracted text
puts extracted_text

# Write the extracted text to a file
File.open('book-input.txt', 'w') do |file|
  file.write(extracted_text)
end

# Read the contents of the input file
puts "Extracted pdf text to database"
