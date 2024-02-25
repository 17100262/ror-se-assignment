class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_api_service

  def index
    begin
      @employees = @api_service.get_all(params[:page])
    rescue StandardError => e
      handle_error("Failed to Fetch employees: #{e.message}", root_path)
    end
  end

  def edit
    begin
      @employee = @api_service.get(params[:id])
    rescue StandardError => e
      handle_error("Failed to Fetch employees: #{e.message}", employees_path)
    end
  end

  def show
    begin
      @employee = @api_service.get(params[:id])
    rescue StandardError => e
      handle_error("Failed to Fetch employees: #{e.message}", employees_path)
    end
  end

  def create
    begin
      @employee = @api_service.create(employee_params)
      redirect_to employee_path(@employee['id'])
    rescue StandardError => e
      handle_error("Failed to create employee: #{e.message}", employees_path)
    end
  end

  def update
    begin
      @employee = @api_service.update(params[:id], employee_params)
      redirect_to edit_employee_path(@employee['id'])
    rescue StandardError => e
      handle_error("Failed to update employee: #{e.message}", employees_path)
    end
  end

  private

  def set_api_service
    @api_service = ApiService.new(base_app_uri, 'employees')
  end

  def employee_params
    params.require(:employee).permit(:name, :position, :date_of_birth, :salary)
  end

  def handle_error(message, fallback_location)
    flash[:alert] = message
    redirect_back(fallback_location: fallback_location)
  end
end
