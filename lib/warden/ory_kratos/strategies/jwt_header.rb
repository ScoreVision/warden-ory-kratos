require 'warden-ory-kratos'
require 'jwt'
require 'net/http'
require 'logger'

module Warden
  module OryKratos
    module Strategies
      class JWTHeader < TokenBase
        self.strategy_name = :JWTHeader.freeze

        KEY_LOADER = -> (options) do
          if options[:kid_not_found] && @cache_last_update < Time.now.to_i - 300
            logger.debug("Invalidating JWK cache. #{options[:kid]} not found from previous cache")
            @cached_keys = nil
          end
          @cached_keys ||= begin
                             @cache_last_update = Time.now.to_i
                               ::JSON.parse(open(JWKS_URL).read)
                           end
        end.freeze

        DECODE_OPTIONS = {
          algorithm: 'ES256',
          jwks: KEY_LOADER,
          verify_expiration: true,
          verify_not_before: true,
          verify_iat: true,
          required_claims: [
            'identity'
          ]
        }.freeze
        JWKS_URL = 'http://localhost:4000/.ory/proxy/jwks.json'.freeze
        VERIFY_SIGNATURE = true.freeze

        class << self
          attr_accessor :jwks_url, :jwk_opts

          def config(jwks_url = nil, decode_opts = nil)
            # TODO: Rewrite the configuration mechanisms.
            @jwks_url = jwks_url || JWKS_URL
            @jwk_opts = decode_opts || DECODE_OPTIONS
          end
        end

        def valid?
          logger.debug("validating #{self.strategy_name}")
          results = []
          Rack::Auth::AbstractRequest::AUTHORIZATION_KEYS.each do |key|
            header_value = env[key]
            results.append(BEARER_PATTERN.match?(header_value))
          end
          results.any?
        end

        def authenticate!
          # Extract encoded JWT from header
          logger.debug('running authenticate!')
          token_string = ''
          Rack::Auth::AbstractRequest::AUTHORIZATION_KEYS.each do |key|
            header_value = env[key]
            if BEARER_PATTERN.match?(header_value)
              m = BEARER_PATTERN.match(header_value)
              token_string = m[:token]
            end
          end

          begin
            decoded_token = JWT.decode(token_string, nil, VERIFY_SIGNATURE, DECODE_OPTIONS, KEY_LOADER)
          rescue JWT::DecodeError => e
            puts "Error type: #{e.class}, message: #{e.message}"
            throw(:warden)
          else
            ident = decoded_token['identity']
            success!(ident)
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