require 'warden-ory-kratos'

module Warden
  module OryKratos
    module Strategies
      class TokenBase < Base
        # https://regexr.com/6s98f
        HEADER_PATTERN = {
          'Authorization': /^Bearer (?<token>[A-Za-z0-9+\/,\-_=.]+)/.freeze,
          'X-Session-Token': /^(?<token>[A-Za-z0-9+\/,\-_=]+)/.freeze
        }.freeze
      end
    end
  end
end
