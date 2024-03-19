require 'net/http'
require 'net/https'

class EmployeesController < ApplicationController
  BASE_URI = "https://dummy-employees-api-8bad748cda19.herokuapp.com/employees"
  before_action :authenticate_user!

  def index
    url = build_url(page)
    response = HttpService.get(url)
    @employees = parse_response(response)
  end

  def edit
    response = HttpService.get(employee_url(id))
    @employee = parse_response(response)
  end

  def show
    response = HttpService.get(employee_url(id))
    @employee = parse_response(response)
  end

  def create
    response = HttpService.post(BASE_URI, params)
    @employee = parse_response(response)

    redirect_to employee_path(@employee.dig("id"))
  end

  def update
    response = HttpService.put(employee_url(id), params)
    @employee = parse_response(response)

    redirect_to edit_employee_path(@employee.dig("id"))
  end

  private

  def page
    params[:page]
  end

  def id
    params[:id]
  end

  def parse_response(response)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

  def build_url(page = nil)
    page.present? ? "#{BASE_URI}?page=#{page}" : BASE_URI
  end

  def employee_url(id)
    "#{BASE_URI}/#{id}"
  end
end
