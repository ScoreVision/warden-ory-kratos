require 'json'
require 'jwt'
require 'open-uri'

module Warden
  module OryKratos
    ##
    # A JWKStore class maps unique keys to +JWT::JWK+ objects
    # and imports JSON web key sets (JWKS) by URI.
    # 
    class JWKStore

      ##
      # Creates a new JWKStore.
      # If a +import_uri+ is given, the URI will be fetched and imported.
      #
      # @example Create new JWKStore with defaults.
      #   store = JWKStore.new
      #
      # @example Load key set at store creation time.
      #   store = JWKStore.new('http://localhost:4000/.ory/jwks.json')
      #
      # @param import_uri [String] a URI of a JSON web key set to import at creation.
      # @return [JWKStore] the new JWKStore.
      def initialize(import_uri=nil)
        @items = {}
        import(import_uri) if import_uri
      end

      ##
      # Returns the JSON web key (JWK) associated with the given index.
      #
      # @param index [String] lookup key.
      # @return [JWT::JWK]
      def [](index)
        @items[index]
      end

      ##
      # Associates the given value with the given index; returns value.
      # If the given key exists, replaces its value with the given value.
      # Values may be converted to +JWT::JWK+ when necessary.
      #
      # @param index [String] lookup key.
      # @param value [JWT::JWK, Hash] JSON web key.
      # @return [JWT::JWK]
      def []=(index, value)
        unless value.is_a?(JWT::JWK)
          value = JWT::JWK.import(value)
        end
        @items[index] = value
        return value
      end

      ##
      # Imports the given JSON web key set (JWKS) URI into the key store.
      # The JWK's key ID will be used as the index.
      #
      # @example Import from Ory cli proxy
      #   store = JWKStore.new
      #   store.import('http://localhost:4000/.ory/jwks.json')
      #
      # @param uri [String] URI to JWKS
      # @return [nil]
      def import(uri)
        jwk_hash = URI.parse(uri).open do |f|
          JSON.parse(f.read)
        end
        jwk_hash["keys"].each do |k|
          jwk = JWT::JWK.import(k)
          @items[jwk.kid] = jwk
        end
      end

      ##
      # Deletes the entry for the given +index+ and returns its associated value.
      # If +index+ is found, deletes the entry and returns the associated value.
      # If +index+ is not found, returns +nil+.
      #
      # @param index [String] lookup key.
      # @return [JWT::JWK, nil]
      def delete(index)
        @items.delete(index)
      end
    end
  end
end
