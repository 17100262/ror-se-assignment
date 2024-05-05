class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_api_client

  def index
    @employees = @api_client.get_employee(page: params[:page])
  end
  
  def edit
    @employee = @api_client.get_employee(params[:id])
  end

  def show
    @employee = @api_client.get_employee(params[:id])
  end

  def create
    employee_params = {
      "name" => params[:name],
      "position" => params[:position],
      "date_of_birth" => params[:date_of_birth],
      "salary" => params[:salary]
    }
    @employee = @api_client.create_or_update_employee(employee_params, method: :post)
    redirect_to employee_path(@employee["id"])
  end
  
  def update
    employee_params = {
      "name" => params[:name],
      "position" => params[:position],
      "date_of_birth" => params[:date_of_birth],
      "salary" => params[:salary]
    }
    @employee = @api_client.create_or_update_employee(employee_params, method: :put, id: params[:id])
    redirect_to edit_employee_path(@employee["id"])
  end

  private

  def set_api_client
    @api_client = EmployeeApiClient.new
  end
end
