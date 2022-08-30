module Warden
  module OryKratos
    class Configuration
      # <https://github.com/feministy/lizabinante.com/blob/stable/source/2016-01-30-creating-a-configurable-ruby-gem.markdown>
      attr_accessor :kratos_external_api, :kratos_internal_api, :kratos_ui, :kratos_proxy_jwks

      def initialize
        @kratos_external_api  = nil
        @kratos_internal_api  = nil
        @kratos_ui            = nil
        @kratos_proxy_jwks    = nil
        # TODO: Add a logger to the config?
      end

      def self.kratos_backend_api
        return @kratos_internal_api || @kratos_external_api
      end
    end
  end
end
