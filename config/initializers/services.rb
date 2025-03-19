Rails.application.config.after_initialize do
  Dir[Rails.root.join('app/services/**/*.rb')].each do |file|
    begin
      require_dependency file
    rescue NameError => e
      Rails.logger.warn "Não foi possível carregar serviço: #{file}. Erro: #{e.message}"
    end
  end
end
