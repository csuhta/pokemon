module Rack
  class SecurityHeaders

    StandardHeaders = {
      "Server" => "Rack",
      "X-UA-Compatible" => "IE=edge",
      "X-Frame-Options" => "DENY",
      "X-Permitted-Cross-Domain-Policies" => "none",
      "X-Content-Type-Options" => "nosniff",
      "X-XSS-Protection" => "1; mode=block",
      "X-Download-Options" => "noopen",
    }.freeze

    CSPHeader = %{
      default-src
        'none';
      style-src
        'self';
      script-src
        https://www.google-analytics.com
        'self';
      img-src
        https://www.google-analytics.com
        data:
        'self';
      font-src
        'self';
      connect-src
        'self';
    }.squish.freeze

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      StandardHeaders.each do |header, value|
        headers[header] = value
      end
      if ENV["RACK_ENV"].eql?("production")
        headers["Content-Security-Policy"] = CSPHeader
        headers["Strict-Transport-Security"] = "max-age=31536000"
      end
      [status, headers, body]
    end

  end
end
