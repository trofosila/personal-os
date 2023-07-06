!include /usr/share/ublue-os/just/bling.just

# Install all flatpaks defined in recipe.yml
flatpaks-setup:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

# Enable AMD P-State CPU Performance Scaling Driver
amd-p-state-enable:
  rpm-ostree kargs --append-if-missing=amd_pstate=passive

# Disable AMD P-State CPU Performance Scaling Driver
amd-p-state-disable:
  rpm-ostree kargs --delete=amd_pstate

# Test AMD P-State CPU Performance Scaling Driver
amd-p-state-test:
  watch -n1 "grep \"^[c]pu MHz\" /proc/cpuinfo"

# Sync changes to .justfile
justfile-update:
  touch ~/.justfile
  cat /usr/share/ublue-os/just/main.just > ~/.justfile
  cat /usr/share/ublue-os/just/nvidia.just >> ~/.justfile
  cat /usr/share/ublue-os/just/custom.just >> ~/.justfile
  sed -i -z 's/!include/#!include/g' .justfile
