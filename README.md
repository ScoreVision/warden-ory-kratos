# Warden::OryKratos

A module providing Warden authentication strategies that integrate with [Ory Kratos](https://www.ory.sh/kratos/).

## RailsWarden usage

_I'll be using warden with Rails, although you are not required to._

Configure rails for use with `rails_warden`. Select the strategies your application will use.

```ruby
# config/initializers/warden.rb
require 'rails_warden'
require 'warden/ory_kratos'

Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.failure_app = Warden::OryKratos::FailureApps::UnAuthorized
  manager.default_strategies [:SessionToken, :SessionCookie]
  # :JWTHeader strategy also available
end
```

Configure Warden::OryKratos

```ruby
# config/environments/development.rb
Warden::OryKratos.configure do |config|
  config.kratos_external_api  = 'https://yourhostedproject.projects.oryapis.com'
  config.logger               = Logger.new(STDOUT)
  # config.kratos_proxy_jwks    = 'http://localhost:4000/.ory/proxy/jwks.json'
end
```

Add the auth mixin to the base controller class of your choosing.

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Mixins were deprecated on master branch
  # include RailsWarden::Mixins
  include RailsWarden::Authentication
end
```

Ensure the controller performs authentication.

```ruby
# app/controllers/articles_controller.rb
class ArticlesController < ApplicationController
  prepend_before_action :authenticate!
  def index
    @articles = Article.all
  end
  # ...
end
```

## Strategies

There are three strategies available. When combined the `:SessionToken`, and `:SessionCookie` strategies make up a "Kratos native" implementation. While the `:JWTHeader` strategy provides compatibility with the Ory cli proxy.

### SessionCookie Strategy

- Looks for an `ory_session` cookie in the rack request.
- Makes an external request to Kratos for the user session.
- Accepts or rejects the request based on the user session information.

### SessionToken Strategy

- Looks within the rack request for a tokens in both `Authorization` and `X_Session_Token` headers.
- Makes an external request to Kratos for the user session.
- Accepts or rejects the request based on the user session information.

### JWTHeader Strategy

- Loads the Ory cli proxy's JSON web key set (JWKS).
- Looks for an `Authorization` header holding a JSON web token (JWT).
- Uses the JWKS to cryptographically verify the JWT was issued by the Ory cli proxy.
- Extracts the user session from the valid JWT.
- Accepts or rejects the request based on the user session information.
