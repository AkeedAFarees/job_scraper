require_relative "boot"

require "rails/all"
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WebScraper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # To allow incoming requests from Optimyse app deployed with CapRover on Mikaels Server
    config.hosts << "job-scrape.cap.mikaels.com"

    # To allow incoming requests from Localhost while running in production mode
    config.hosts << "localhost"

    # To allow incoming requests from app server deployed through Capistrano
    config.hosts << "209.97.130.157"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
