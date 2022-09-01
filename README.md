# Warden::OryKratos

A module providing Warden authentication strategies that integrate with [Ory Kratos](https://www.ory.sh/kratos/).

## Module configuration

```ruby
# TODO: Add module configuration example here
```

## Strategies

TODO: Add configuration instructions for each strategy as required. 

### SessionCookie Strategy

### SessionToken Strategy

### JWTHeader Strategy


### Example

### Get Token

```shell
actionUrl=$(\
  curl -s -X GET -H "Accept: application/json" \
    "https://playground.projects.oryapis.com/self-service/login/api" \
    | jq -r '.ui.action'\
)
sessionToken=$(curl -s -X POST -H  "Accept: application/json" -H "Content-Type: application/json" \
    -d '{"identifier": "bob@example.com", "password": "bobsyouruncle", "method": "password"}' \
    "$actionUrl" | jq -r '.session_token')
```
