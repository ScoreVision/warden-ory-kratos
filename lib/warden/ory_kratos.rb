# frozen_string_literal: true
require 'warden'
require_relative 'ory_kratos/configuration'
require_relative 'ory_kratos/strategies'
require_relative 'ory_kratos/version'
require_relative 'ory_kratos/failure_apps/unauthorized'

module Warden
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
