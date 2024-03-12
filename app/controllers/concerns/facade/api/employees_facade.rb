require 'net/http'
require 'net/https'

module Facade
  module Api
    class EmployeesFacade
      API_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze

      def self.index(page = nil)
        uri = URI("#{API_URL}?page=#{page}")
        response = make_request(uri)
        parse_response(response)
      end

      def self.show(id)
        uri = URI("#{API_URL}/#{id}")
        response = make_request(uri)
        parse_response(response)
      end

      def self.create(params)
        uri = URI(API_URL)
        response = make_post_request(uri, params.to_json)
        parse_response(response)
      end

      def self.update(id, params)
        uri = URI("#{API_URL}/#{id}")
        response = make_put_request(uri, params.to_json)
        parse_response(response)
      end

      private
      def self.make_request(uri, request_type = Net::HTTP::Get, body = nil)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')

        request = request_type.new(uri)
        request['Content-Type'] = 'application/json'
        request.body = body if body

        http.request(request)
      end

      def self.make_post_request(uri, body)
        make_request(uri, Net::HTTP::Post, body)
      end

      def self.make_put_request(uri, body)
        make_request(uri, Net::HTTP::Put, body)
      end

      def self.parse_response(response)
        JSON.parse(response.body)
      rescue JSON::ParserError
        # Handle parsing error
        nil
      end
    end

  end
end