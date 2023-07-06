!include /usr/share/ublue-os/just/bling.just

# install all flatpaks defined in recipe.yml
setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

# Include some of your custom scripts here!
enable-amd-p-state:
  rpm-ostree kargs --append-if-missing=amd_pstate=passive

disable-amd-p-state:
  rpm-ostree kargs --delete=amd_pstate

test-amd-p-state:
  watch -n1 "grep \"^[c]pu MHz\" /proc/cpuinfo"
