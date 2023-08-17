!include /usr/share/ublue-os/just/bling.just

# Install all flatpaks defined in recipe.yml
setup-flatpaks:
  #!/usr/bin/env bash
  echo 'Installing flatpaks from the ublue recipe ...'
  flatpaks=$(yq -- '.firstboot.flatpaks[]' "/usr/share/ublue-os/recipe.yml")
  for pkg in $flatpaks; do \
      echo "Installing: ${pkg}" && \
      flatpak install --user --noninteractive flathub $pkg; \
  done

# Include some of your custom scripts here!

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
  sed -i 's/^!include/#!include/g' .justfile

# Install rootless AWS CLI https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
aws-cli-install:
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  mkdir -p ~/.local/bin
  ./aws/install -i ~/.local/aws-cli -b ~/.local/bin
  aws --version
  rm awscliv2.zip
  rm -r aws

# Install rootless AWS SAM CLI https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html
aws-sam-install:
  curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o aws-sam-cli-linux-x86_64.zip
  unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
  mkdir -p ~/.local/bin
  ./sam-installation/install -i ~/.local/aws-sam-cli -b ~/.local/bin
  sam --version
  rm aws-sam-cli-linux-x86_64.zip
  rm -r sam-installation

# # Install rootless Docker https://docs.docker.com/engine/security/rootless/
# docker-install:
#   curl -fsSL https://get.docker.com/rootless | sh
#   echo "DOCKER_HOST=unix:///run/user/$UID/docker.sock" >> ~/.bashrc
#   systemctl --user start docker
#   systemctl --user enable docker
