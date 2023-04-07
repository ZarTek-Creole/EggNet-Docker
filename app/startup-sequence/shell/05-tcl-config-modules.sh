#!/bin/bash

# Enable Eggdrop modules
enable_modules() {
  local module
  for module in "${EGG_MODULES_ENABLE[@]}"; do
    sed -i "s@#loadmodule ${module}@loadmodule ${module}@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf" || {
      echo "Failed to enable module ${module}. Exiting..."
      exit 1
    }
  done
}

# Main function
main() {
  enable_modules
}

# Run the script
main "$@"
