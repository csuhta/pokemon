require "brochure"
require "dalli"
require "active_support/core_ext/object"
require "active_support/core_ext/string"
require "active_support/core_ext/array"
require "active_support/core_ext/enumerable"
require "rack-force_domain"
require "rack/cache"
require "rack/ssl"
require "sass"
require "sass-globbing"
require "sprockets"
require "uglifier"
require "./security"

# Patch a security vulnerability in Brochure
module Brochure
  class Application
    def forbidden?(path)
      path[".."] || File.basename(path)[/^_/] || path["//"]
    end
  end
end

# Add module for security headers
module Rack
  class CustomHeaders
    def initialize(app)
      @app = app
    end
    def call(env)
      status, headers, body = @app.call(env)
      headers['X-Custom-Header'] = "customheader.v1"
      [status, headers, body]
    end
  end
end

# Print logs correctly inside of foreman
STDOUT.sync = true

# Use gzip compression
use Rack::Deflater

# Answer HEAD requests
use Rack::Head

# Force SSL if specified
use Rack::SSL if ENV["FORCE_HTTPS"]

# Force a domain name if specified
use Rack::ForceDomain, ENV["DOMAIN"]

# Load the security headers module
use Rack::SecurityHeaders

# Use a memory cache if available
if ENV["MEMCACHIER_SERVERS"]
  cache = Dalli::Client.new ENV["MEMCACHIER_SERVERS"].split(","), {
    username: ENV["MEMCACHIER_USERNAME"],
    password: ENV["MEMCACHIER_PASSWORD"]
  }
  cache.flush # Flush the cache on boot or restart
  use Rack::Cache, {
    metastore: cache,
    entitystore: cache,
    verbose: true,
    default_ttl: 2628000
  }
end

# If set, present an HTTP basic auth block
if ENV["HTTP_USERNAME"] && ENV["HTTP_PASSWORD"]
  use Rack::Auth::Basic, "Restricted Site" do |username, password|
    [username, password] == [
      ENV.fetch("HTTP_USERNAME"),
      ENV.fetch("HTTP_PASSWORD")
    ]
  end
end

# Serve FED assets with Sprockets
map "/assets" do
  environment = Sprockets::Environment.new
  environment.js_compressor = :uglify if ENV["RACK_ENV"] == "production"
  environment.css_compressor = :scss if ENV["RACK_ENV"] == "production"
  environment.append_path "assets/javascripts"
  environment.append_path "assets/stylesheets"
  environment.append_path "assets/images"
  environment.append_path "assets/fonts"
  run environment
end

# Serve ERB templates with Brochure
map "/" do
  run Brochure.app(File.dirname(__FILE__))
end
