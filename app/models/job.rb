class Job < ApplicationRecord
  include Filterable

  scope :filter_by_keyword, -> (search_word) {
    where(
      " LOWER(title) like ? OR
        LOWER(company) like ? OR
        LOWER(published_type) like ? OR
        LOWER(skill) like ?",
      "%#{search_word}%", "%#{search_word}%", "%#{search_word}%", "%#{search_word}%"
    )}
end
