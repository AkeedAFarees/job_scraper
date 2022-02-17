class Skill < ApplicationRecord
  include Filterable

  scope :filter_by_keyword, -> (search_word) {
    where(
      "LOWER(name) like ? OR cast(min as text) like ? OR cast(max as text) like ? OR LOWER(experience) like ?",
      "%#{search_word}%", "%#{search_word}%", "%#{search_word}%", "%#{search_word}%"
    )}
end
