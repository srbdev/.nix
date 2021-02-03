#!/usr/bin/env bash

set -Eeuo pipefail

update_system () {
  sudo apt update && sudo apt upgrade -y
}

fresh_install () {
  sudo apt install man-db -y
  sudo apt install make build-essential -y
  sudo apt install jq -y
}


setup_bash () {
  cp .bash_aliases ~/.bash_aliases
  cp .bash_functions ~/.bash_functions

  printf "if [ -f ~/.bash_functions ]; then\n\t. ~/.bash_functions\nfi\n\n" >> ~/.bashrc
  echo "PS1='\${debian_chroot:+(\$debian_chroot)}digitalocean \w\$ '" >> ~/.bashrc
}

setup_git () {
  ssh-keygen -t ed25519 -C "sylvain.rb@gmail.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519

  git config --global user.name "srbdev"
  git config --global user.email sylvain.rb@gmail.com
  git config --global push.default simple
}


setup_neovim () {
  mkdir -p ~/.config/nvim/pack/airblade/start
  cp .config/nvim/init.vim ~/.config/nvim/
  cp .config/flake8 ~/.config/
  cp .pylintrc ~/.pylintrc
  cp .jshintrc ~/.jshintrc

  mkdir -p ~/.local/share/nvim/site/pack/git-plugins/start
  cp .local/share/nvim/site/pack/git-plugins/start/update.sh ~/.local/share/nvim/site/pack/git-plugins/start/

  mkdir -p ~/.local/share/nvim/site/pack/kwbd/start/kwbd.vim/start
  cp .local/share/nvim/site/pack/kwbd/start/kwbd.vim/start/kwbd.vim ~/.local/share/nvim/site/pack/kwbd/start/kwbd.vim/start/

  (cd ~/.config/nvim/pack/airblade/start && \
    git clone https://github.com/airblade/vim-gitgutter.git && \
    nvim -u NONE -c "helptags vim-gitgutter/doc" -c q)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/terryma/vim-multiple-cursors.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/jiangmiao/auto-pairs.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/preservim/nerdcommenter.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/alvan/vim-closetag.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://tpope.io/vim/surround.git && \
    nvim -u NONE -c "helptags surround/doc" -c q)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/preservim/nerdtree.git &&
    nvim -u NONE -c "helptags ~/.local/share/nvim/site/pack/git-plugins/start/nerdtree/doc" -c q)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/itchyny/lightline.vim.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/arcticicestudio/nord-vim.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone --depth 1 https://github.com/dense-analysis/ale.git)

  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/fatih/vim-go.git)
}

install_neovim () {
  sudo apt install neovim -y
  setup_neovim
}


setup_tmux () {
  mkdir -p ~/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  cp .tmux.conf ~/.tmux.conf
}


install_fzf () {
  echo "export FZF_DEFAULT_COMMAND='find --type f'" >> ~/.bashrc
  echo "export FZF_DEFAULT_OPTS='--height 20% --layout=reverse'" >> ~/.bashrc
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
}


install_go () {
  (cd && wget https://golang.org/dl/go1.15.7.linux-$(dpkg --print-architecture).tar.gz)
  (cd && sudo tar -C /usr/local -xzf go1.15.7.linux-$(dpkg --print-architecture).tar.gz)
  mkdir -p ~/go/bin
  mkdir -p ~/go/src/github.com/srbdev
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
  export PATH="$PATH:/usr/local/go/bin" && go version
}


install_docker () {
  sudo mkdir /etc/systemd/system/docker.service.d

  sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io -y

  sudo systemctl daemon-reload
  sudo systemctl restart docker

  sudo docker run --rm hello-world

  sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  docker-compose --version

  (base=https://github.com/docker/machine/releases/download/v0.16.2 && \
    curl -L $base/docker-machine-$(uname -s)-$(uname -m) > /tmp/docker-machine && \
    sudo mv /tmp/docker-machine /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine)
  docker-machine --version

  sudo usermod -aG docker sb
}


print_sshkey() {
  echo
  cat ~/.ssh/id_ed25519.pub
  echo
}


the_end () {
  echo "done."
}


main () {
  update_system
  fresh_install

  setup_bash
  setup_git
  setup_tmux

  install_neovim
  install_fzf
  install_go
  install_docker

  print_sshkey

  the_end
}
main
