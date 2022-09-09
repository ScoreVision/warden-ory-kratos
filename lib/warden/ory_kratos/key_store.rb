require 'json'
require 'jwt'
require 'open-uri'

module Warden
  module OryKratos
    class JWKStore
      def initialize(import_uri=nil)
        @items = {}
        import(import_uri) if import_uri
      end

      def [](index)
        @items[index]
      end

      def []=(index, value)
        if jwk.is_a?(JWT::JWK)
          @items[index] = value
        else
          @items[index] = JWT::JWK.import(value)
        end
      end

      def import(uri)
        jwk_hash = URI.parse(uri).open do |f|
          JSON.parse(f.read)
        end
        jwk_hash["keys"].each do |k|
          jwk = JWT::JWK.import(k)
          @items[jwk.kid] = jwk
        end
      end

      def delete(index)
        @items.delete(index)
      end

      def fetch(index)
        @items[index]
      end
    end
  end
end
