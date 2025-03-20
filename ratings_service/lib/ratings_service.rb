# ratings_service/lib/ratings_service.rb
require "ratings_service/version"
require "ratings_service/engine"

module RatingsService
  mattr_accessor :court_updated_callback
  mattr_accessor :user_updated_callback
  
  def self.configure
    yield self
  end
end