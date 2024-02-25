# app/services/api_service.rb
class ApiService
  def initialize(base_uri, resource)
    @base_uri = base_uri
    @resource = resource
  end

  def get(id)
    uri = URI("#{@base_uri}/#{@resource}/#{id}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def get_all(page = nil)
    uri = URI("#{@base_uri}/#{@resource}")
    uri.query = URI.encode_www_form({ page: page }) if page.present?
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def create(params)
    uri = URI("#{@base_uri}/#{@resource}")
    response = send_api_request(:post, uri, params)
    JSON.parse(response)
  end

  def update(id, params)
    uri = URI("#{@base_uri}/#{@resource}/#{id}")
    response = send_api_request(:put, uri, params)
    JSON.parse(response)
  end

  private

  def send_api_request(method, uri, params = {})
    uri = URI(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')

    request_class = case method
                    when :post
                      Net::HTTP::Post
                    when :put
                      Net::HTTP::Put
                    end

    request = request_class.new(uri.path)
    request['Content-Type'] = 'application/json'
    request.body = employee_params.to_json

    begin
      response = http.request(request)
      JSON.parse(response.body)
    rescue StandardError => e
      puts "Error: #{e.message}"
      raise e
    end
  end
end
