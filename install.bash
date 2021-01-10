#!/usr/bin/env bash

update_system () {
  sudo apt install && sudo apt upgrade -y
}

fresh_install () {
  read -p "Is this a fresh Ubuntu install? [y/N] " answer
  case "$answer" in
    y|Y )
      sudo apt install man-db -y
      sudo apt install make build-essential -y
      sudo apt install vim -y
      sudo apt install tmux -y
      sudo apt install htop -y
      sudo apt install wget -y
      sudo apt install curl -y
      sudo apt install jq -y
      ;;
    * ) echo "skipping fresh install setup";;
  esac
}


setup_bash () {
  read -p "Do you want to setup bash? [y/N] " answer
  case "$answer" in
    y|Y )
      cp .bash_aliases ~/.bash_aliases
      cp .bash_functions ~/.bash_functions

      printf "if [ -f ~/.bash_functions ]; then\n\t. ~/.bash_functions\nfi\n\n" >> ~/.bashrc
      echo "PS1='\${debian_chroot:+(\$debian_chroot)}changeme \w\$ '" >> ~/.bashrc
      ;;
    * ) echo "skipping bash setup";;
  esac
}

setup_git () {
  read -p "Do you want to setup git? [y/N] " answer
  case "$answer" in
    y|Y )
      ssh-keygen -t ed25519 -C "sylvain.rb@gmail.com"
      eval "$(ssh-agent -s)"
      ssh-add ~/.ssh/id_ed25519

      git config --global --edit
      git config --global push.default simple
      ;;
    * ) echo "skipping git setup";;
  esac
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
  read -p "Do you want to install neovim? [y/N] " answer
  case "$answer" in
    y|Y ) sudo apt install neovim -y;;
    * ) echo "skipping neovim install";;
  esac

  read -p "Do you want to setup neovim? [y|N] " answer
  case "$answer" in
    y|Y ) setup_neovim;;
    * ) echo "skipping neovim setup";;
  esac
}


setup_tmux () {
  read -p "Do you want to install tmux? [y/N] " answer
  case "$answer" in
    y|Y )
      mkdir -p ~/.tmux/plugins
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      cp .tmux.conf ~/.tmux.conf
      ;;
    * ) echo "skipping tmux install";;
  esac
}


install_pyenv () {
  read -p "Do you want to install pyenv? [y/N] " answer
  case "$answer" in
    y|Y )
      sudo apt-get update; sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
      git clone https://github.com/pyenv/pyenv.git ~/.pyenv
      echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
      echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
      echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc

      mkdir -p ~/.pyenv/plugins
      git clone https://github.com/pyenv/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv
      ;;
    * ) echo "skipping pyenv install";;
  esac

  read -p "Do you want to setup pyenv? [y|N] " answer
  case "$answer" in
    y|Y )
      echo "not implemented!"
      ;;
    * ) echo "skipping pyenv setup";;
  esac
}


install_fzf () {
  read -p "Do you want to install fzf? [y/N] " answer
  case "$answer" in
    y|Y )
      echo "export FZF_DEFAULT_COMMAND='find --type f'" >> ~/.bashrc
      echo "export FZF_DEFAULT_OPTS='--height 20% --layout=reverse'" >> ~/.bashrc
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install
      ;;
    * ) echo "skipping fzf install";;
  esac
}


install_go () {
  read -p "Do you want to install Go? [y/N] " answer
  case "$answer" in
    y|Y )
      (cd && wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz)
      (cd && sudo tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz)
      mkdir -p ~/go/bin
      mkdir -p ~/go/src/github.com/srbdev
      echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
      export PATH="$PATH:/usr/local/go/bin" && go version
      ;;
    * ) echo "skipping go install";;
  esac
}


install_rust () {
  read -p "Do you want to install rust? [y/N] " answer
  case "$answer" in
    y|Y ) curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh;;
    * ) echo "skipping rust install";;
  esac
}


install_docker () {
  read -p "Do you want to install Docker? [y/N] " answer
  case "$answer" in
    y|Y )
      sudo mkdir /etc/systemd/system/docker.service.d

      sudo apt-get remove docker docker-engine docker.io containerd runc
      sudo apt-get update
      sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo apt-key fingerprint 0EBFCD88
      sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get update
      sudo apt-get install docker-ce docker-ce-cli containerd.io -y

      sudo systemctl daemon-reload
      sudo systemctl restart docker

      sudo docker run --rm hello-world
      ;;
    * ) echo "skipping Docker install";;
  esac

  read -p "Do you want to install docker-compose? [y/N] " answer
  case "$answer" in
    y|Y )
      sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
      docker-compose --version
      ;;
    * ) echo "skipping docker-compose install";;
  esac

  read -p "Do you want to install docker-machine? [y/N] " answer
  case "$answer" in
    y|Y )
      (base=https://github.com/docker/machine/releases/download/v0.16.2 && \
        curl -L $base/docker-machine-$(uname -s)-$(uname -m) > /tmp/docker-machine && \
        sudo mv /tmp/docker-machine /usr/local/bin/docker-machine && \
        chmod +x /usr/local/bin/docker-machine)
      docker-machine --version
      ;;
    * ) echo "skipping docker-machine install";;
  esac

  read -p "Do you want to use Docker as a non-root user? [y/N] " answer
  case "$answer" in
    y|Y )
      echo "run: sudo usermod -aG docker [username]"
      ;;
    * ) echo "skipping running Docker as a non-root user";;
  esac
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
  install_pyenv
  install_go
  install_rust
  install_docker

  the_end
}
main
