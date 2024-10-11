class ImportBlogsJob < ApplicationJob
  queue_as :default

  BATCH_SIZE = 1000

  def perform(file_path, user_id)
    blogs_to_insert = []
    CSV.foreach(file_path, headers: true, encoding: 'utf-8') do |row|
      blog_attributes = row.to_h.slice('title', 'body')
      blogs_to_insert << blog_attributes.merge(user_id: user_id)
      # Insert the blogs in batches to avoid running out of memory
      if blogs_to_insert.size >= BATCH_SIZE
        insert_blogs(blogs_to_insert)
        blogs_to_insert.clear
      end
    end
    # Insert the remaining blogs
    insert_blogs(blogs_to_insert) unless blogs_to_insert.empty?
  end

  private

  def insert_blogs(blogs)
    Blog.insert_all(blogs)
  end
end