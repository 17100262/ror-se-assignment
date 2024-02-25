require 'net/http'

class EmployeesController < ApplicationController
  before_action :authenticate_user!

  def index
    uri = URI(employees_uri(params[:page]))
    @response = Net::HTTP.get(uri)
    @employees = JSON.parse(@response)
  end

  def edit
    uri = URI(employee_uri(params[:id]))
    @response = Net::HTTP.get(uri)
    @employee = JSON.parse(@response)
  end

  def show
    uri = URI(employee_uri(params[:id]))
    @response = Net::HTTP.get(uri)
    @employee = JSON.parse(@response)
  end

  def create
    uri = URI(employee_uri(params[:id]))


    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = (uri.scheme == 'https')

    request = Net::HTTP::Post.new(uri.path)

    request['Content-Type'] = 'application/json'

    body = {
      "name": params[:name],
      "position": params[:position],
      "date_of_birth": params[:date_of_birth],
      "salary": params[:salary]
    }.to_json
    request.body = body

    response = http.request(request)

    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"

    @employee = JSON.parse(response.body)

    redirect_to employee_path(@employee.dig("id"))
  end

  def update

    uri = URI(employee_uri(params[:id]))


    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = (uri.scheme == 'https')

    request = Net::HTTP::Put.new(uri.path)

    request['Content-Type'] = 'application/json'

    body = {
      "name": params[:name],
      "position": params[:position],
      "date_of_birth": params[:date_of_birth],
      "salary": params[:salary]
    }.to_json
    request.body = body

    response = http.request(request)

    puts "Response Code: #{response.code}"
    puts "Response Body: #{response.body}"

    @employee = JSON.parse(response.body)

    redirect_to edit_employee_path(@employee.dig("id"))
  end

  private

  def employee_uri(id)
    base_app_uri + "/employees/#{id}"
  end

  def employees_uri(paginate = nil)
    base_app_uri + "/employees?page=#{paginate}" if paginate.present?
    base_app_uri + '/employees'
  end
end
