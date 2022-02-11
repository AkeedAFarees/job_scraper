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
    # Hard code URLs for both website with empty query parameters
    cv_url                = "https://cv.ee/en/search?keywords%5B0%5D="
    credit_info_url       = "https://www.e-krediidiinfo.ee/otsing?&q="

    # Initiate empty array for bulk creation of jobs in database
    records             = []

    browser_options = if ENV['GOOGLE_CHROME_SHIM'].present?
                        {
                          headless: true,
                          options: { binary: ENV['GOOGLE_CHROME_SHIM'] },
                          switches: %w(--ignore-certificate-errors --disable-popup-blocking --disable-translate --disable-gpu)
                        }
                      else
                        {}
                      end
    # Initiate browser window
    browser               = Watir::Browser.new(:chrome, browser_options)

    # Fetch job titles and companies to reduce duplication
    jobs = Job.all.select(:title, :company).map{|j| j.title + j.company}

    # Loop through all skills
    skills.each do |skill|
      # Visit url and look for jobs based on specific skill
      browser.goto        cv_url + skill
      parsed_page         = Nokogiri::HTML(browser.html)

      # Fetch all jobs from parsed HTML page returned from browser
      fetched_jobs        = parsed_page.css('div.vacancy-item')

      # Loop through each job
      fetched_jobs.each do |job|
        # Find Job Title and Job Link from the parsed HTML
        title             = job.children.last.css('span.vacancy-item__title').text
        link              = job.children.first.attributes["href"].value

        # Extract main info of the job
        main_info         = job.children.css('div.vacancy-item__info-main').children.map{|e| e.text}

        # Extract company name
        company_name      = main_info.first

        # Extract and process all info related to publishing of the job (Time and Type)
        publish_info      = main_info.last.split(" | ").first.split(" ", 2)

        time_ago          = publish_info.last.split(" ").reject{|t| t == "about"}
        published_date    = time_ago[0].to_i.send(time_ago[1]).ago.to_date
        published_type    = publish_info.first

        # Skip iteration to stop duplication of record, if published date of current job is older than today.
        # That means it must already be in database.
        if jobs.include?(title + company_name)
          next
        end

        # Visit second website to fetch credit info for the company
        browser.goto      credit_info_url + company_name
        credit_info_page  = Nokogiri::HTML(browser.html)

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
          link:           "https://cv.ee" + link,
          skill:          skill,
          title:          title,
          company:        company_name,
          revenue:        revenue || nil,
          published_date: published_date,
          published_type: published_type,
          revenue_period: revenue_period || nil,
          created_at:     Time.now.utc,
          updated_at:     Time.now.utc
        }

        # Push hash to array
        records.push(single_job)
      end
    end

    # Close browser connection
    browser.close

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
