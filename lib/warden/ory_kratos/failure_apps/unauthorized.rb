module Warden
  module OryKratos
    module FailureApps
      ##
      # A simple default failure application
      #
      class UnAuthorized
        def self.call(env)
          Rack::Response.new('unauthroized', '401', {'Content-Type' => 'text/plain'})
        end
      end
    end
  end
end
