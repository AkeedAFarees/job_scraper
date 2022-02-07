module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(search_word)
      results = self.where(nil)

      results = results.public_send("filter_by_keyword", search_word.downcase) if search_word.present?
      # filtering_params = %w(title company published_type skill)
      # filtering_params.each do |key|
      #   results = results.public_send("filter_by_#{key}", search_word) if search_word.present?
      # end
      results
    end
  end
end