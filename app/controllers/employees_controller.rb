require 'net/http'
require 'net/https'

class EmployeesController < ApplicationController
  before_action :authenticate_user!
  
    def index
      uri = params[:page].present? ? construct_employee_uri("paginated_employees", params[:page]) : construct_employee_uri("employees_endpoint", nil)

      @response = Net::HTTP.get(uri)
      @employees = employee_json(@response)
    end
  
    def edit
      uri = construct_employee_uri("specific_employee", params[:id])

      @response = Net::HTTP.get(uri)
      @employee = employee_json(@response)
    end

    def show
      uri = construct_employee_uri("specific_employee", params[:id])

      @response = Net::HTTP.get(uri)
      @employee = employee_json(@response)
    end

    def create
      uri = construct_employee_uri("specific_employee", params[:id])
      @employee = employee_create_or_update_request(uri, "POST")
      redirect_to employee_path(@employee.dig("id"))
    end
  
    def update
      uri = construct_employee_uri("specific_employee", params[:id])
      @employee = employee_create_or_update_request(uri, "PUT")
      redirect_to edit_employee_path(@employee.dig("id"))
    end  

    private

    def construct_employee_uri(link, params)
      URI("#{endpoints[link]}#{params}")
    end 

    def endpoints
      YAML.load_file("#{Rails.root}/config/endpoints.yml")[Rails.env]
    end

    def employee_create_or_update_request(uri, http_verb)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      
      request = ["POST"].include?(http_verb) ? Net::HTTP::Post.new(uri.path) : Net::HTTP::Put.new(uri.path)
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

      employee_json(response.body)
    end

    def employee_json(response)
      JSON.parse(response)
    end
end
