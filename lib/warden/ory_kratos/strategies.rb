module Warden::OryKratos
  module Strategies
    require_relative 'strategies/base'
    require_relative 'strategies/token_base'
    require_relative 'strategies/jwt_header'
    require_relative 'strategies/session_cookie'
    require_relative 'strategies/session_token'
  end
end
