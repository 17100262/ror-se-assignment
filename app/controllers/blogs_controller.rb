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
  def show; end

  # GET /blogs/new
  def new
    @blog = current_user.blogs.new
  end

  # GET /blogs/1/edit
  def edit; end

  # POST /blogs or /blogs.json
  def create
    @blog = current_user.blogs.new(blog_params)

    respond_to do |format|
      if @blog.save
        format.html { redirect_to blog_url(@blog), notice: I18n.t('blogs.save.success', action: params[:action]) }
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
        format.html { redirect_to blog_url(@blog), I18n.t('blogs.save.success', action: params[:action]) }
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
      format.html { redirect_to blogs_url, I18n.t('blogs.delete.success') }
      format.json { head :no_content }
    end
  end

  def import
    # Enqueue the CSV import task
    CsvImportWorker.perform_async(File.realpath(params[:attachment].original_filename), current_user.id)

    redirect_to blogs_path, notice: 'CSV file import has been queued for processing.'
  rescue CSV::MalformedCSVError => e
    redirect_to blogs_path, alert: "Error parsing CSV file: #{e.message}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = current_user.blogs.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.require(:blog).permit(:title, :body, :user_id)
    end
end
