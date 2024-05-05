class EmployeesController < ApplicationController
  before_action :authenticate_user!

  def index
    @employees = Employees::Api.get_all(params[:page])
  end

  def edit
    @employee = Employees::Api.get_employee(params[:id])
  end

  def show
    @employee = Employees::Api.get_employee(params[:id])
  end

  def create
    response = Employees::Api.create_employee(employee_params)
    redirect_to employee_path(response["id"])
  end

  def update
    response = Employees::Api.update_employee(params[:id], employee_params)
    redirect_to edit_employee_path(response["id"])
  end

  private

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end
end
