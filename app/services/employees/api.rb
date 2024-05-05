require 'net/http'
require 'net/https'
require 'uri'

class Employees::Api
  API_BASE_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze

 # for index
  def self.get_all(page = nil)
    uri = URI("#{API_BASE_URL}?page=#{page}")
    response = send_get_request(uri)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

 # for show
  def self.get_employee(id)
    uri = URI("#{API_BASE_URL}/#{id}")
    response = send_get_request(uri)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end

 # for creation
  def self.create_employee(params)
    uri = URI(API_BASE_URL)
    send_post_request(uri, params)
  end

 # for updation
  def self.update_employee(id, params)
    uri = URI("#{API_BASE_URL}/#{id}")
    send_put_request(uri, params)
  end

  private

  def self.send_get_request(uri)
    Net::HTTP.get_response(uri)
  end

  def self.send_post_request(uri, params)
    send_request(uri, Net::HTTP::Post, params)
  end

  def self.send_put_request(uri, params)
    send_request(uri, Net::HTTP::Put, params)
  end

  def self.send_request(uri, request_type, params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request = request_type.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = params.to_json

    response = http.request(request)
    JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
  end
end
