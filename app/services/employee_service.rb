require 'net/http'
require 'net/https'
class EmployeeService
    def initialize
      @base_url = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'
    end
  
    def fetch_all(page = nil)
      uri = URI(@base_url)
      uri.query = URI.encode_www_form(page: page) if page.present?
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end
  
    def fetch(id)
      uri = URI("#{@base_url}/#{id}")
      response = Net::HTTP.get(uri)
      JSON.parse(response)
    end
  
    def create(params)
      uri = URI(@base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      request = Net::HTTP::Post.new(uri.path)
      request['Content-Type'] = 'application/json'
      request.body = params.to_json
      response = http.request(request)
      JSON.parse(response.body)
    end
  
    def update(id, params)
      uri = URI("#{@base_url}/#{id}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == 'https')
      request = Net::HTTP::Put.new(uri.path)
      request['Content-Type'] = 'application/json'
      request.body = params.to_json
      response = http.request(request)
      JSON.parse(response.body)
    end
  end
  