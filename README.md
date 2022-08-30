# Warden::OryKratos

A Warden authentication strategy that integrates with Ory Kratos.

## Usage

### Configuration

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
