# app/workers/csv_import_worker.rb
require 'csv'
class CsvImportWorker
  include Sidekiq::Worker

  def perform(full_path, current_user_id)
    batch_size = 1000
    batch = []

    CSV.foreach(full_path, headers: true) do |row|
      blog_attributes = row.to_h.merge(user_id: current_user_id)
      batch << blog_attributes

      if batch.size >= batch_size
        Blog.insert_all(batch)
        batch = []
      end
    end

    Blog.insert_all(batch) unless batch.empty?
  end
end