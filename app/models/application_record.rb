class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  #Paginate records on index
  def self.paginate(params)
    if params[:page] == "all"
      page(1).per(999)
    else
      page(params[:page] || 1).per(params[:per_page] || Kaminari.config.default_per_page)
    end
  end

end
