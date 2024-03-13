# app/controllers/employees_controller.rb
class EmployeesController < ApplicationController
  before_action :authenticate_user!

  def index
    page = params[:page]
    @employees = EmployeeApiService.fetch_all_employees(page)
  end

  def edit
    @employee = EmployeeApiService.fetch_employee(params[:id])
  end

  def show
    @employee = EmployeeApiService.fetch_employee(params[:id])
  end

  def create
    params = employee_params
    @employee = EmployeeApiService.create_employee(params)
    redirect_to employee_path(@employee.dig("id"))
  end

  def update
    params = employee_params
    @employee = EmployeeApiService.update_employee(params[:id], params)
    redirect_to edit_employee_path(@employee.dig("id"))
  end

  private

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end
end
