require "warden"
require_relative 'warden/ory_kratos/version'

module Warden::OryKratos
  require_relative 'warden/ory_kratos/configuration'
  require_relative 'warden/ory_kratos/strategies'
  require_relative 'warden/ory_kratos/failure_apps/unauthorized'
end