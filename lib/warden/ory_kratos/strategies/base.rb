module Warden
  module OryKratos
    module Strategies
      ##
      # Provides a base class to build strategies from.
      # @abstract
      #
      class Base < Warden::Strategies::Base
        class << self
          attr_accessor :strategy_name
        end
        def store?
          false
        end
      end
    end
  end
end
