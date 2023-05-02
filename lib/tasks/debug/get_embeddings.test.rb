require 'json'

book_title = "Romeo and Juliet"

book_sections = BookSection.where(title: book_title)

display = book_sections.map { |book_section| 
  book_section["content"] = book_section["content"].gsub("\n", " ")
}

puts display[0].length
puts display[1].length
puts display[2].length
puts display.length

puts "Embeddings read from database"

