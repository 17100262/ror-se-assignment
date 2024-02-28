require 'csv'
class BlogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_blog, only: %i[ show edit update destroy ]

  # GET /blogs or /blogs.json
  def index
    # @blogs = current_user.blogs
    @pagy, @blogs = pagy(current_user.blogs)

  end

  # GET /blogs/1 or /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = current_user.blogs.new
  end

  # GET /blogs/1/edit
  def edit
  end

  # POST /blogs or /blogs.json
  def create
    @blog = current_user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blogs/1 or /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to blog_url(@blog), notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1 or /blogs/1.json
  def destroy
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to blogs_url, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def import
    file = params[:attachment]
    # Initialize batch size for processing
    batch_size = 20
    # Initialize an array to store blog attributes
    blog_attributes = []
    if file.present? && file.content_type == 'text/csv'
      # Bulk Create Blog Records
      begin
        #Process CSV data in batches
        CSV.foreach(file.path, headers: true, encoding: 'utf-8') do |row|
          blog_attributes << row.to_h
          # If the batch size is reached, insert records into the database
          if blog_attributes.size >= batch_size
            # Start a transaction for batch insertion
            ActiveRecord::Base.transaction do
              current_user.blogs.create!(blog_attributes)
            end
            # Clear the array for the next batch
            blog_attributes.clear
          end
        end
    
        # Insert any remaining records after processing
        unless blog_attributes.empty?
          ActiveRecord::Base.transaction do
            current_user.blogs.create!(blog_attributes)
          end
        end

        flash[:notice] = "data successfully import."
      rescue StandardError => e
        flash[:notice] = "An error occurred : #{e.message}"
      end
    else
      flash[:notice] = "Invalid csv file"
    end
    # End code to handle CSV data
    redirect_to blogs_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = current_user.blogs.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :body, :user_id)
    end
end
