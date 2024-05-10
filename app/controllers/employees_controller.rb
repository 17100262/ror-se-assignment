require 'net/http'
require 'net/https'

class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emp_api_service
  before_action :set_employee, only: %i[ show edit update ]

  def index
    @employees = @emp_api_service.get_all_employees(page: params[:page])
  end

  def edit; end

  def show; end

  def create
    employee_params = {
      "name" => params[:name],
      "position" => params[:position],
      "date_of_birth" => params[:date_of_birth],
      "salary" => params[:salary]
    }
    @employee = @emp_api_service.create_or_update_employee(employee_params, method: :post)
    redirect_to employee_path(@employee["id"])
  end

  def update
    employee_params = {
      "name" => params[:name],
      "position" => params[:position],
      "date_of_birth" => params[:date_of_birth],
      "salary" => params[:salary]
    }
    @employee = @emp_api_service.create_or_update_employee(employee_params, method: :put, id: params[:id])
    redirect_to edit_employee_path(@employee["id"])
  end

  private

  def set_emp_api_service
    @emp_api_service = EmployeeApiService.new
  end

  def set_employee
    @employee = @emp_api_service.get_employee(id: params[:id])
  end
end
