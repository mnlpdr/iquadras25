# ratings_service/lib/ratings_service/engine.rb
module RatingsService
  class Engine < ::Rails::Engine
    isolate_namespace RatingsService
    
    initializer "ratings_service.assets" do |app|
      app.config.assets.precompile += %w( ratings_service/application.css ratings_service/application.js )
    end
    
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
  end
end