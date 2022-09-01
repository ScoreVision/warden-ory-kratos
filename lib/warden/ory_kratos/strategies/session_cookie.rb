require 'net/http'
require 'logger'

module Warden
  module OryKratos
    module Strategies
      class SessionCookie < Base
        self.strategy_name = :SessionCookie.freeze
        COOKIE_PREFIX = 'ory_session'.freeze
        SESSION_PATH = '/sessions/whoami'.freeze

        def valid?
          OryKratos.configuration.logger&.debug("validating with #{SessionCookie.strategy_name}")
          # Parse incoming request and look for a kratos session cookie
          request = Rack::Request.new(env)
          request.cookies.each_key do |k|
            # Check for kratos session cookies
            if k.start_with?(COOKIE_PREFIX)
              return true
            end
          end
          # No kratos session cookies found
          false
        end

        def authenticate!
          OryKratos.configuration.logger&.debug("authenticating with #{SessionCookie.strategy_name}")
          # Parse kratos session cookie from incoming request
          incoming_request = Rack::Request.new(env)
          kratos_cookie = ''
          incoming_request.cookies.each do |k, v|
            if k.start_with?(COOKIE_PREFIX)
              kratos_cookie += "#{k}=#{v};"
            end
          end

          # Verify session with Kratos API
          # Build request URL
          uri = URI("#{OryKratos.configuration.kratos_backend_api}#{SESSION_PATH}")
          # Build request object, and make request
          session_response = Net::HTTP.start(
            uri.host,
            uri.port,
            :use_ssl => uri.scheme == 'https'
          ) do |http|
            request = Net::HTTP::Get.new uri
            request['Accept'] = 'application/json'
            request['cookie'] = kratos_cookie
            http.request request
          end
          # Parse kratos session response
          identity_session = ::JSON.parse(session_response.body)
          if identity_session['active'] == true
            success!(identity_session['identity'])
          end
        end
      end
    end
  end
end

::Warden::Strategies.add(
  Warden::OryKratos::Strategies::SessionCookie.strategy_name,
  Warden::OryKratos::Strategies::SessionCookie
)