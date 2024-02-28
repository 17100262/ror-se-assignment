class EmployeesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @employees = employee_service.fetch_all(params[:page])
  end
  
  def edit
    @employee = employee_service.fetch(params[:id])
  end

  def show
    @employee = employee_service.fetch(params[:id])
  end

  def create
    @employee = employee_service.create(employee_params)
    handle_response(@employee, :create)
  end
  
  def update
    @employee = employee_service.update(params[:id], employee_params)
    handle_response(@employee, :update)
  end  

  private

  def employee_service
    @employee_service ||= EmployeeService.new
  end

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end

  def handle_response(employee, action)
    if employee.present? && employee['id'].present?
      redirect_to employee_path(employee['id'])
    else
      flash[:error] = "Failed to #{action} employee"
      render action == :create ? :new : :edit
    end
  end
end
