# Set the number of Puma worker processes per dyno
workers ENV.fetch("WEB_CONCURRENCY", 1).to_i

# Use the rackup command to tell Puma how to start your rack app.
# This should execute config.ru.
rackup DefaultRackup

# Set the port to listen on.
# Heroku sets this for you in production.
port ENV.fetch("PORT", 8080).to_i

# The environment to boot
environment ENV.fetch("RACK_ENV", "development")

on_worker_boot do
  # Do nothing extra for just Rack
end
