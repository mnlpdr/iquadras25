# Puma can serve each request in a thread from an internal thread pool.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 16 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Specify the port puma will listen on
# Alterado para rodar APENAS na porta 3000
port ENV.fetch("PORT") { 3000 }

# Specify the environment
environment ENV.fetch("RAILS_ENV") { "development" }

# Disable workers completely in development
workers 0

# Clean up any existing pid file
before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.config do |config|
    config.ram           = 1024 # mb
    config.frequency     = 5    # seconds
    config.percent_usage = 0.98
  end
  PumaWorkerKiller.start
  FileUtils.rm_f('tmp/pids/server.pid')
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart

# Set up socket for better performance
# A linha abaixo foi removida pois já estamos definindo a porta acima
# bind "tcp://127.0.0.1:3000"

# Increase the timeout
persistent_timeout 65

# Run the Solid Queue supervisor inside of Puma for single-server deployments
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# Store the pid file
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Log more information about processes
stdout_redirect 'log/puma.stdout.log', 'log/puma.stderr.log', true

# Garante que cada worker reconecte ao banco de dados ao iniciar
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
