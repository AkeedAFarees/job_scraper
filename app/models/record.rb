class Record < ApplicationRecord

  # Bulk upload records
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      record_hash = Record.new
      record_hash.dev_name = row[0]
      record_hash.skills = row[1]
      record_hash.save
    end
  end

  def self.scrape(skill)
    cv_url            = "https://cv.ee/en/search?keywords%5B0%5D=#{skill}"
    credit_info_url   = "https://www.e-krediidiinfo.ee/otsing?&q="

    browser = Watir::Browser.new
    browser.goto cv_url
    parsed_page = Nokogiri::HTML(browser.html)

    CSV.open("storage/#{Time.now.iso8601}.csv", "a+") do |csv|
      csv << ["Company Name", "Job Tile", "Job Link", "Published Date", "Revenue", "Revenue Period"]

      jobs = parsed_page.css('div.vacancy-item')
      jobs.each do |job|
        title = job.children.last.css('span.vacancy-item__title').text
        link = job.children.first.attributes["href"].value

        main_info = job.children.css('div.vacancy-item__info-main').children.map{|e| e.text}

        company_name = main_info.first
        published_date = main_info.last.split(" | ").first

        browser.goto credit_info_url + company_name
        credit_info_page = Nokogiri::HTML(browser.html)

        if credit_info_page.at('table.table-search') == nil
          revenue_row = credit_info_page.at('table').search('tr')[-3].children.text.split("\n").map(&:strip).select(&:present?).last.split(" (perioodil ")
          revenue = revenue_row.first
          dates = revenue_row.last.gsub(")","").split(" - ").map(&:to_datetime)
          revenue_period = (dates.last - dates.first).to_i.to_s + " days"
        end

        csv << [company_name, title, link, published_date, revenue ||=0 , revenue_period ||= 0]
      end
    end

    browser.close

  end

end
