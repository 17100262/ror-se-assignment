# app/jobs/csv_import_worker.rb
class CsvImportWorker
    include Sidekiq::Worker
    queue_as :default
    require 'csv'
    BATCH_SIZE = 1000
  
    def perform(user_id, file_path)
      user = User.find(user_id)
  
      begin
        # Perform the CSV import in batches using Sidekiq
        CSV.foreach(file_path, headers: true, encoding: 'utf-8').each_slice(BATCH_SIZE) do |rows|
          # Use a transaction for better performance and reliability
          ActiveRecord::Base.transaction do
            rows.each do |row|
              user.blogs.create!(row.to_h)
            end
          end
        end
      rescue StandardError => e
        Rails.logger.error("CsvImportWorker Error: #{e.message}")
        raise e
      end
    end
  end
  