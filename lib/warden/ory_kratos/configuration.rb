module Warden
  module OryKratos
    ##
    # A Configuration class for the OryKratos module.
    #
    #
    # @note Thanks to {https://github.com/feministy/lizabinante.com/blob/stable/source/2016-01-30-creating-a-configurable-ruby-gem.markdown}
    class Configuration
      attr_accessor :jwk_decode_opt, :jwk_verify_sig, :kratos_proxy_jwks,
                    :kratos_external_api, :kratos_internal_api, :kratos_ui,
                    :logger
      attr_reader :JWT_DECODE_OPTIONS, :JWT_VERIFY_SIGNATURE, :JWKS_URL

      # Default decode options.
      JWT_DECODE_OPTIONS = {
        algorithm: 'ES256',
        verify_expiration: true,
        verify_not_before: true,
        verify_iat: true,
        required_claims: ['exp', 'iat', 'session'].freeze
      }.freeze
      # Default signature verification option
      JWT_VERIFY_SIGNATURE = true.freeze

      # Default Ory cli proxy JWKS url
      JWKS_URL = 'http://localhost:4000/.ory/jwks.json'.freeze

      ##
      # Creates a new Configuration.
      #
      # @example Create new Configuration.
      #   configuration = Configuration.new
      #
      # @return [nil]
      def initialize
        @jwk_decode_opt = JWT_DECODE_OPTIONS
        @jwk_verify_sig = JWT_VERIFY_SIGNATURE
        @kratos_proxy_jwks = JWKS_URL
        @kratos_external_api = nil
        @kratos_internal_api = nil
        @kratos_ui = nil
        @logger = nil
      end

      ##
      # Returns the URI, possibly private, that should be used to access the Kratos from
      #
      # @return [String]
      def kratos_backend_api
        return @kratos_internal_api || @kratos_external_api
      end
    end
  end
end
