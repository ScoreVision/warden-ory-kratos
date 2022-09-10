require 'net/http'

module Warden
  module OryKratos
    module Strategies
      ##
      # A warden strategy used to authenticate session tokens.
      #
      class SessionToken < TokenBase
        self.strategy_name = :SessionToken.freeze
        SESSION_PATH = '/sessions/whoami'.freeze

        def valid?
          OryKratos.configuration.logger&.debug("validating with #{SessionToken.strategy_name}")
          # We need the incoming request
          request = Rack::Request.new(env)
          # We need to check if the auth headers exist
          HEADER_PATTERN.each do |name, pattern|
            header_value = request.fetch_header("HTTP_#{name.upcase}") do
              ''
            end
          # We need to validate the header data
            if pattern.match?(header_value)
              return true
            end
          end
          false
        end

        def authenticate!
          OryKratos.configuration.logger&.debug("authenticating with #{SessionToken.strategy_name}")
          # We need the incoming request
          request = Rack::Request.new(env)

          # We need to find any tokens
          tokens = []
          HEADER_PATTERN.each do |name, pattern|
            header_value = request.fetch_header("HTTP_#{name.upcase}") do
              ''
            end
            pattern.match(header_value) do |m|
              # Append a token when we have a match
              tokens.append(m[:token])
            end
          end

          # We need to turn the token in for a kratos session
          # We need the session URI
          uri = URI("#{OryKratos.configuration.kratos_backend_api}#{SESSION_PATH}")
          # We need to request the kratos session
          session_response = Net::HTTP.start(
            uri.host,
            uri.port,
            :use_ssl => uri.scheme == 'https'
          ) do |http|
            request = Net::HTTP::Get.new uri
            request['Accept'] = 'application/json'
            request['Authorization'] = "Bearer #{tokens[0]}"
            http.request request
          end
          # We need to parse the kratos API response
          identity_session = ::JSON.parse(session_response.body)
          # We need to ensure the session is active
          if identity_session['active'] == true
            # We need to pass the user to Warden
            success!(identity_session['identity'])
          end
        end
      end
    end
  end
end

::Warden::Strategies.add(
  Warden::OryKratos::Strategies::SessionToken.strategy_name,
  Warden::OryKratos::Strategies::SessionToken
)