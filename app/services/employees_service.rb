# app/services/employees_service.rb
class EmployeesService
  def initialize(uri)
    @uri = uri
  end

  def fetch_employees(page = nil)
    uri = @uri + (page.present? ? "?page=#{page}" : "")
    response = send_request(uri)
    JSON.parse(response.body)
  end

  def fetch_employee(id)
    uri = "#{@uri}/#{id}"
    response = send_request(uri)
    JSON.parse(response.body)
  end

  def create_employee(params)
    response = send_request(@uri, method: :post, body: params.to_json)
    JSON.parse(response.body)
  end

  def update_employee(id, params)
    uri = "#{@uri}/#{id}"
    response = send_request(uri, method: :put, body: params.to_json)
    JSON.parse(response.body)
  end

  private

  def send_request(uri, method: :get, body: nil)
    uri = URI(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP.const_get(method.capitalize).new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = body if body.present?
    http.request(request)
  end
end
