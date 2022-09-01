module Warden
  module OryKratos
    module Strategies
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
