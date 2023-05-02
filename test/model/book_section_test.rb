require 'test_helper'

class BookSectionTest < ActiveSupport::TestCase
  # Test the validations for the BookSection model
  test 'should not save book section without content' do
    book_section = BookSection.new(title: 'Some content', embeddings: [])
    assert_not book_section.save, 'Saved the book section without a title'
  end

  # Test the validations for the BookSection model
  test 'should not save book section without title' do
    book_section = BookSection.new(content: 'Some content', embeddings: [])
    assert_not book_section.save, 'Saved the book section without a title'
  end
      
  # Test the validations for the BookSection model
  test 'should not save book section without embedding' do
    book_section = BookSection.new(title: 'Some title', content: 'Some content')
    assert_not book_section.save, 'Saved the book section without an embedding'
  end

end
