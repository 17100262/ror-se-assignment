require 'net/http'
require 'net/https'
require 'uri'

class EmployeeApiService
  BASE_URL = "https://dummy-employees-api-8bad748cda19.herokuapp.com/employees"

  def initialize
    @uri = URI(BASE_URL)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
  end

  def get_all_employees(page: nil)
    path = "#{BASE_URL}?page=#{page}"
    response = @http.get(path)
    JSON.parse(response.body)
  end

  def get_employee(id)
    path = "#{BASE_URL}/#{id}"
    response = @http.get(path)
    JSON.parse(response.body)
  end

  def upsert_employee(employee, request_method:, id: nil)
    path = id.present? ? "#{BASE_URL}/#{id}" : BASE_URL
    uri = URI(path)
    request = if request_method == :post
                Net::HTTP::Post.new(uri.path)
              else
                Net::HTTP::Put.new(uri.path)
              end
    request['Content-Type'] = 'application/json'
    request.body = employee.to_json
    response = @http.request(request)
    JSON.parse(response.body)
  end
end