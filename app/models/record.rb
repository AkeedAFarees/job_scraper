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

  def self.scrape(skills)
    # Require open-uri to parse through the urls
    require 'open-uri'

    # Initiate empty array for bulk creation of jobs in database
    records             = []

    # Hard code URLs for both website with empty query parameters
    api_url          = "https://cv.ee/api/v1/vacancies-service/search?limit=20&offset=0&fuzzy=true&isHourlySalary=false&isRemoteWork=false&lang=en&keywords[]="
    site_url         = "https://cv.ee/et/vacancy/"
    credit_info_url  = "https://www.e-krediidiinfo.ee/otsing?&q="

    # Fetch job titles and companies to reduce duplication
    jobs = Job.pluck(:title, :company).map(&:join)

    # Loop through all skills
    skills.each do |skill|
      # Visit url and look for jobs based on specific skill
      content = JSON.parse(URI.parse(api_url + skill).read)

      if content["vacancies"].present?
        # Loop through each job
        content["vacancies"].each do |job|

        # Skip iteration to stop duplication of record, if published date of current job is older than today.
        # That means it must already be in database.
        if jobs.include?(job["positionTitle"] + job["employerName"])
          next
        end

        # Visit second website to fetch credit info for the company
        url = Addressable::URI.parse(credit_info_url + job["employerName"]).display_uri.to_s
        credit_info_page  = Nokogiri::HTML(URI.parse(url).read)

        # If table exists, it means there are multiple results for the company name
        # Extract revenue info if there is a direct hit on company name
        if credit_info_page.at('table.table-search') == nil
          revenue_row     = credit_info_page.at('table').search('tr')[-3].children.text.split("\n").map(&:strip).select(&:present?).last.split(" (perioodil ")
          revenue         = revenue_row.first
          dates           = revenue_row.last.gsub(")","").split(" - ").map(&:to_datetime)
          revenue_period  = (dates.last - dates.first).to_i.to_s + " days"
        else
          # Write logic to do same processing as above for the very first record if there are multiple hits on the company name
        end

        # Create a populated hash to push in records array for bulk creation.
        single_job = {
          skill:          skill,
          title:          job["positionTitle"],
          company_id:     job["employerId"],
          company:        job["employerName"],
          link:           site_url + job["id"].to_s + '/' + job["employerName"].parameterize + '/' + job["positionTitle"].parameterize,
          published_date: job["publishDate"],
          published_type: job["renewedDate"].present? ? "Renewed" : "Published",
          renewed_date:   job["renewedDate"],

          revenue:        revenue || nil,
          revenue_period: revenue_period || nil,
          created_at:     Time.now.utc,
          updated_at:     Time.now.utc
        }

        # Push hash to array
        records.push(single_job)
      end
      end
    end

    Job.insert_all!(records) if records.present?
  end

  def self.export_to_csv(jobs)
    attributes = %w{Title Company Link Published_Date Published_Type Revenue Revenue_Period Skill}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      jobs.each do |job|
        csv << attributes.map{ |attr| job.send(attr.downcase) }
      end
    end
  end
  
end
