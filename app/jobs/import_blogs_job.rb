class ImportBlogsJob < ApplicationJob
  queue_as  :default

  BATCH_SIZE = 1000

  def perform(current_user, file_path)
    batch = []

    # Process the CSV line by line instaed of loading the entire file
    CSV.foreach(file_path, headers: true, encoding: 'utf-8') do |blog|
      blog_attributes = blog.to_h
      blog_attributes.merge(user_id: current_user)
      batch << blog_attributes

      # When batch size is reached, insert into database
      if batch.size >= BATCH_SIZE
        ActiveRecord::Base.transaction do
          Blog.insert_all(batch)
        end
        batch = [] # Reset batch for next iteration
      end
    end

    # Insert remaining records if there is any
    Blog.insert_all(batch) unless batch.empty?

    redirect_to blogs_path
  end
end