class EmployeesController < ApplicationController
  include Facade::Api
  before_action :authenticate_user!
  before_action :set_employee, only: %i[show edit]

  def index
    @employees = EmployeesFacade.index(params[:page])
  end

  def new; end

  def edit; end

  def show; end

  def create
    @employee = EmployeesFacade.create(employee_params)
    redirect_page
  end

  def update
    @employee = EmployeesFacade.update(params[:id], employee_params)
    redirect_page
  end

  private

  def set_employee
    @employee = EmployeesFacade.show(params[:id])
  end

  def redirect_page
    if @employee
      redirect_to employee_path(@employee['id']), notice: I18n.t('employees.save.success', action: params[:action])
    else
      redirect_to employees_path, notice: I18n.t('employees.save.failure')
    end
  end

  def employee_params
    params.permit(:name, :position, :date_of_birth, :salary)
  end
end
