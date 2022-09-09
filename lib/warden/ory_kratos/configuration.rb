module Warden
  module OryKratos
    class Configuration
      # <https://github.com/feministy/lizabinante.com/blob/stable/source/2016-01-30-creating-a-configurable-ruby-gem.markdown>
      attr_accessor :jwk_decode_opt, :jwk_verify_sig, :jwks_url,
                    :kratos_external_api, :kratos_internal_api, :kratos_ui,
                    :kratos_proxy_jwks, :logger

      JWT_DECODE_OPTIONS = {
        algorithm: 'ES256',
        verify_expiration: true,
        verify_not_before: true,
        verify_iat: true,
        required_claims: ['exp', 'iat', 'session'].freeze
      }.freeze
      JWT_VERIFY_SIGNATURE = true.freeze
      JWKS_URL = 'http://localhost:4000/.ory/jwks.json'.freeze

      def initialize
        @jwk_decode_opt = JWT_DECODE_OPTIONS
        @jwk_verify_sig = JWT_VERIFY_SIGNATURE
        @jwks_url = JWKS_URL
        @kratos_external_api = nil
        @kratos_internal_api = nil
        @kratos_ui = nil
        @kratos_proxy_jwks = nil
        @logger = nil
      end

      def kratos_backend_api
        return @kratos_internal_api || @kratos_external_api
      end

    end
  end
end
