require 'net/http'
require 'uri'
require 'json'

class RatingsServiceClient
  BASE_URL = ENV.fetch('RATINGS_SERVICE_URL', 'http://localhost:3001/api/v1')
  
  class RatingsServiceError < StandardError; end

  class << self
    def get_court_ratings(court_id)
      endpoint = court_id ? "ratings?court_id=#{court_id}" : "ratings"
      response = make_request(
        method: :get,
        endpoint: endpoint
      )
      
      parse_response(response)
    end

    def get_court_average_rating(court_id)
      response = make_request(
        method: :get,
        endpoint: "courts/#{court_id}/average_rating"
      )
      
      parse_response(response)
    end

    def get_user_ratings(user_id)
      response = make_request(
        method: :get,
        endpoint: "users/#{user_id}/ratings"
      )
      
      parse_response(response)
    end

    def create_rating(court_id:, user_id:, score:, comment: nil)
      response = make_request(
        method: :post,
        endpoint: "ratings",
        body: {
          rating: {
            court_id: court_id,
            user_id: user_id,
            score: score,
            comment: comment
          }
        }
      )
      
      parse_response(response)
    end

    def update_rating(id:, score: nil, comment: nil)
      rating_params = {}
      rating_params[:score] = score if score
      rating_params[:comment] = comment if comment

      response = make_request(
        method: :patch,
        endpoint: "ratings/#{id}",
        body: {
          rating: rating_params
        }
      )
      
      parse_response(response)
    end

    def delete_rating(id)
      response = make_request(
        method: :delete,
        endpoint: "ratings/#{id}"
      )
      
      response.code == '204'
    end

    private

    def make_request(method:, endpoint:, body: nil, headers: {})
      url = URI.parse("#{BASE_URL}/#{endpoint}")
      
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = url.scheme == 'https'
      
      request = case method
                when :get
                  Net::HTTP::Get.new(url)
                when :post
                  req = Net::HTTP::Post.new(url)
                  req.body = body.to_json if body
                  req
                when :patch
                  req = Net::HTTP::Patch.new(url)
                  req.body = body.to_json if body
                  req
                when :delete
                  Net::HTTP::Delete.new(url)
                else
                  raise ArgumentError, "Método HTTP não suportado: #{method}"
                end
      
      request['Content-Type'] = 'application/json'
      headers.each { |key, value| request[key] = value }
      
      begin
        http.request(request)
      rescue StandardError => e
        raise RatingsServiceError, "Erro na comunicação com o serviço de avaliações: #{e.message}"
      end
    end

    def parse_response(response)
      case response.code
      when '200', '201'
        JSON.parse(response.body, symbolize_names: true)
      when '204'
        true
      when '404'
        nil
      else
        error_message = begin
                          JSON.parse(response.body)['error'] || "Erro desconhecido (HTTP #{response.code})"
                        rescue
                          "Erro desconhecido (HTTP #{response.code})"
                        end
        raise RatingsServiceError, error_message
      end
    end
  end
end