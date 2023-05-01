class RenameBooksToBookSections < ActiveRecord::Migration[7.0]
  def change
    rename_table :books, :book_sections
  end
end
