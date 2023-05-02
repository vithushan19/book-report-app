class BookQuestion < ApplicationRecord

    # Model Validation
    validates :book_title, presence: true
    validates :question, presence: true
    validates :answer, presence: true
end
