class BookSection < ApplicationRecord
    # Model Validation
    validates :title, presence: true
    validates :content, presence: true
    validates :embeddings, presence: true
end
