module Warden
  module OryKratos
    module Strategies
      ##
      # Provides a base class to build strategies from.
      # @abstract
      #
      class TokenBase < Base
        # https://regexr.com/6s98f
        # When we lookup the headers in the request, rack will have
        # converted hyphens to underscores.
        HEADER_PATTERN = {
          'Authorization' => /^Bearer (?<token>[A-Za-z0-9+\/,\-_=.]+)/.freeze,
          'X_Session_Token' => /^(?<token>[A-Za-z0-9+\/,\-_=]+)/.freeze
        }.freeze
      end
    end
  end
end
