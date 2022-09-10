# frozen_string_literal: true
require 'warden'
require_relative 'ory_kratos/configuration'
require_relative 'ory_kratos/strategies'
require_relative 'ory_kratos/version'
require_relative 'ory_kratos/failure_apps/unauthorized'

module Warden
  ##
  # Ory Kratos extension for Warden.
  #
  # Consists of three strategies. Two make up a "kratos native" experience
  # while the third adds support for the Ory cli proxy.
  #
  module OryKratos
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration ||= Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
