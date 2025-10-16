#!/bin/bash

if [ -z "$VAULT_PATH" ]; then
  VAULT_PATH=$(source .env; echo $VAULT_PATH)
fi

VAULT_PATH=$(source .env; echo $VAULT_PATH)

# Check if the VAULT_PATH is set
if [ -z "$VAULT_PATH" ]; then
  echo "VAULT_PATH is not set. Please set the VAULT_PATH environment variable to .env file."
  exit 1
fi

# Check if VAULT_ADDR and VAULT_TOKEN are set
if [ -z "$VAULT_ADDR" ] || [ -z "$VAULT_TOKEN" ]; then
  echo "VAULT_ADDR or VAULT_TOKEN is not set. Please use withhcv command"
  exit 1
fi

SECRETS=$(vault read -field data -format json $VAULT_PATH)

# Check if the SECRETS is empty
if [ -z "$SECRETS" ]; then
  echo "No secrets found in the path $VAULT_PATH."
  exit 1
fi

# Parse the variables and inject them to the process
DART_DEFINE_OPTIONS=$(echo "$SECRETS" | jq -r '
  to_entries |
  map(select(.key != "FCM_ANDROID_GOOGLE_SERVICES" and .key != "FCM_IOS_GOOGLE_SERVICE_INFO" and .key != "ANDROID_UPLOAD_KEY_PROPERTIES" and .key != "ANDROID_UPLOAD_KEYSTORE" and .value != null)) |
  map("--" + .key + "=" + (.value | tostring)) |
  join(" ")
')

echo "Secrets loaded successfully."
eval "fvm dart run dart_define generate $DART_DEFINE_OPTIONS"