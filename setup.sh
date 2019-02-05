#!/bin/bash

url_idea=https://download.jetbrains.com/idea/ideaIC-2018.3.3.tar.gz
repo_docker=https://download.docker.com/linux/fedora/docker-ce.repo

dnf upgrade -y 
rpm --import https://packages.microsoft.com/keys/microsoft.asc

sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf config-manager --add-repo ${repo_docker}

dnf check-update

dnf install java-11-openjdk docker-ce nodejs code terminator chromium chromium-libs-media-freeworld git zoom snapd -y

snap install gitkraken

systemctl start docker

usermod -aG docker ${USER}

systemctl enable docker

curl --output idea.tar.gz -J -L ${url_idea}

mkdir -p /opt/idea

tar -xf idea.tar.gz -C /opt/idea --strip 1

chown ${USER}:${USER} -R /opt

chmod +x -R /opt/idea

curl -s "https://get.sdkman.io" | bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install springboot 2>/dev/null

cat > /home/${USER}/.config/terminator/config <<EOL
[global_config]
[keybindings]
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      type = Terminal
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    background_darkness = 0.6
    background_type = transparent
    cursor_color = "#aaaaaa"
    foreground_color = "#00ff00"

EOL

echo "parse_git_branch() {" >> /home/${USER}/.bash_profile
echo "     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'" >> /home/${USER}/.bash_profile
echo "}" >> /home/${USER}/.bash_profile
echo 'export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "' >> /home/${USER}/.bash_profile

source /home/${USER}/.bash_profile


