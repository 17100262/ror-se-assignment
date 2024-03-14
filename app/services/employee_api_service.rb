require 'net/http'

class EmployeeApiService
    API_BASE_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze
  
    def self.fetch_all_employees(page = nil)
      uri = URI("#{API_BASE_URL}?page=#{page}")
      fetch_data(uri)
    end
  
    def self.fetch_employee(id)
      uri = URI("#{API_BASE_URL}/#{id}")
      fetch_data(uri)
    end
  
    def self.create_employee(params)
      uri = URI(API_BASE_URL)
      send_request(uri, Net::HTTP::Post, params)
    end
  
    def self.update_employee(id, params)
      uri = URI("#{API_BASE_URL}/#{id}")
      send_request(uri, Net::HTTP::Put, params)
    end
  
    private
  
    def self.fetch_data(uri)
      response = Net::HTTP.get_response(uri)
      parse_response(response)
    end
  
    def self.send_request(uri, request_class, params)
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

      
      parse_response(response)
    end
  
    def self.parse_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        raise "API Request Failed. Response Code: #{response.code}, Response Body: #{response.body}"
      end
    end
  end
  