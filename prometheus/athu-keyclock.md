```ini
[auth.generic_oauth]
enabled = true
name = SingleSignOn
allow_sign_up = true
client_id = grafana-dashboard-client
client_secret = h1UEkI7694zjC2dPRTpGhz75XwgL24u8
scopes = openid profile email 
auth_url = https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/auth
token_url = https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/token
api_url = https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/userinfo
role_attribute_path = contains(realm_access.roles[*], 'admin') && 'Admin' || contains(realm_access.roles[*], 'editor') && 'Editor' || 'Viewer'
redirect_url = http://52.206.111.2:3000/oauth/callback
logout_url = https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/logout
```

**For Docker ENV**
```bash
GF_AUTH_GENERIC_OAUTH_ENABLED: true
GF_AUTH_GENERIC_OAUTH_NAME: SingleSignOn
GF_AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP: true
GF_AUTH_GENERIC_OAUTH_CLIENT_ID: grafana-dashboard-client
GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET: h1UEkI7694zjC2dPRTpGhz75XwgL24u8
GF_AUTH_GENERIC_OAUTH_SCOPES: openid profile email 
GF_AUTH_GENERIC_OAUTH_AUTH_URL: https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/auth
GF_AUTH_GENERIC_OAUTH_TOKEN_URL: https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/token
GF_AUTH_GENERIC_OAUTH_API_URL: https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/userinfo
GF_AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_PATH: contains(realm_access.roles[*], 'admin') && 'Admin' || contains(realm_access.roles[*], 'editor') && 'Editor' || 'Viewer'
GF_AUTH_GENERIC_OAUTH_REDIRECT_URL: http://localhost:3000/oauth/callback
GF_AUTH_GENERIC_OAUTH_LOGOUT_URL: https://keycloak.fourcodes.net/realms/fourcodes/protocol/openid-connect/logout
```
