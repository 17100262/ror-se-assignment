require 'net/http'
require 'net/https'

class HttpService
  BASE_URI = "https://dummy-employees-api-8bad748cda19.herokuapp.com/employees"

  def self.get(uri)
    uri = URI(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP::Get.new(uri)
    http.request(request)
  end

  def self.post(uri, body)
    uri = URI(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = body.to_json
    http.request(request)
  end

  def self.put(uri, body)
    uri = URI(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request = Net::HTTP::Put.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = body.to_json
    http.request(request)
  end
end