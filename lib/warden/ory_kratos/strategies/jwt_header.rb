require 'jwt'
require 'net/http'
require 'logger'
require 'json'

module Warden
  module OryKratos
    module Strategies
      class JWTHeader < TokenBase
        self.strategy_name = :JWTHeader.freeze
        @key_store = OryKratos::JWKStore.new(OryKratos.configuration.jwks_url)

        def valid?
          OryKratos.configuration.logger&.debug("validating #{JWTHeader.strategy_name}")
          results = []
          Rack::Auth::AbstractRequest::AUTHORIZATION_KEYS.each do |key|
            header_value = env[key]
            results.append(HEADER_PATTERN['Authorization'].match?(header_value))
          end
          results.any?
        end

        def authenticate!
          # Extract encoded JWT from header
          OryKratos.configuration.logger&.debug("authenticating with #{JWTHeader.strategy_name}")
          token_string = ''
          Rack::Auth::AbstractRequest::AUTHORIZATION_KEYS.each do |key|
            header_value = env[key]
            if HEADER_PATTERN['Authorization'].match?(header_value)
              m = HEADER_PATTERN['Authorization'].match(header_value)
              token_string = m[:token]
            end
          end

          begin
            decoded_token = JWT.decode(token_string, nil, OryKratos.configuration.jwk_verify_sig, OryKratos.configuration.jwk_decode_opt) do |header|
              jwk = @key_store[header['kid']]
              jwk.keypair
            end
          rescue JWT::DecodeError => e
            OryKratos.configuration.logger&.debug("Error type: #{e.class}, message: #{e.message}")
            throw(:warden)
          else
            identity_session = decoded_token[0]['session']
            OryKratos.configuration.logger&.debug(identity_session)
            if identity_session['active'] == true
              success!(identity_session['identity'])
            end
          end
        end
      end
    end
  end
end

::Warden::Strategies.add(
  Warden::OryKratos::Strategies::JWTHeader.strategy_name,
  Warden::OryKratos::Strategies::JWTHeader
)