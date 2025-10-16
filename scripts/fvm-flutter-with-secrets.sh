#!/bin/bash

# Extract the command and arguments
COMMAND="$*"


# Check if the COMMAND is empty
if [ -z "$COMMAND" ]; then
  echo "No command provided. Please provide a command to run."
  exit 1
fi

# Check if command begins with 'fvm ' and remove it
if [[ $COMMAND == "fvm "* ]]; then
  COMMAND="${COMMAND:4}"
fi

# Check if command begins with 'flutter ' and remove it
if [[ $COMMAND == "flutter "* ]]; then
  COMMAND="${COMMAND:7}"
fi

VAULT_PATH=$(source .env; echo $VAULT_PATH)

# Check if the VAULT_PATH is set
if [ -z "$VAULT_PATH" ]; then
  echo "VAULT_PATH is not set. Please set the VAULT_PATH environment variable to .env file."
  exit 1
fi

# Check if the withhcv command is available
if ! command -v withhcv &> /dev/null; then
  echo "withhcv command is not available. Please install withhcv CLI."
  exit 1
fi

# Check if vault command is available
if ! command -v vault &> /dev/null; then
  echo "vault command is not available. Please install vault CLI."
  exit 1
fi

SECRETS=$(withhcv vault read -field data -format json $VAULT_PATH)

# Check if the SECRETS is empty
if [ -z "$SECRETS" ]; then
  echo "No secrets found in the path $VAULT_PATH."
  exit 1
fi

DART_DEFINE_OPTIONS=$(echo "$SECRETS" | jq -r '
  to_entries |
  map(select(.key != "FCM_ANDROID_GOOGLE_SERVICES" and .key != "FCM_IOS_GOOGLE_SERVICE_INFO" and .key != "ANDROID_UPLOAD_KEY_PROPERTIES" and .key != "ANDROID_UPLOAD_KEYSTORE" and .value != null)) |
  map("--dart-define=" + .key + "=" + (.value | tostring)) |
  join(" ")
')

echo "Secrets loaded successfully."

eval "fvm flutter $COMMAND $DART_DEFINE_OPTIONS"