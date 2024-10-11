require 'net/http'
require 'net/https'
require 'uri'

class EmployeeApiClient
  BASE_URL = "https://dummy-employees-api-8bad748cda19.herokuapp.com/employees"

  def initialize
    @uri = URI(BASE_URL)
    @http = Net::HTTP.new(@uri.host, @uri.port)
    @http.use_ssl = true
  end

  def get_employee(id = nil, page: nil)
    path = id ? "#{BASE_URL}/#{id}" : BASE_URL
    path += "?page=#{page}" if page
    response = @http.get(path)
    JSON.parse(response.body)
  end

  def create_or_update_employee(employee, method:, id: nil)
    path = id ? "#{BASE_URL}/#{id}" : BASE_URL
    uri = URI(path)
    request = if method == :post
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
