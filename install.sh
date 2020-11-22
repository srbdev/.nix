#!/bin/bash

update_system () {
  sudo apt install && sudo apt upgrade -y
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
    git clone https://github.com/elixir-editors/vim-elixir.git)
    
  (cd ~/.local/share/nvim/site/pack/git-plugins/start && \
    git clone https://github.com/fatih/vim-go.git)

  sudo apt install jq -y
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


install_tmux () {
  read -p "Do you want to install tmux? [y/N] " answer
  case "$answer" in
    y|Y )
      sudo apt install tmux -y
      mkdir -p ~/.tmux/plugins
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
      cp .tmux.conf ~/.tmux.conf
      ;;
    * ) echo "skipping tmux install";;
  esac
}


setup_bash () {
  read -p "Do you want to setup bash? [y/N] " answer
  case "$answer" in
    y|Y )
      cp .bash_aliases ~/.bash_aliases
      cp .bash_functions ~/.bash_functions
      ;;
    * ) echo "skipping bash setup";;
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
}


install_fdfind () {
  read -p "Do you want to install fd? [y/N] " answer
  case "$answer" in
    y|Y ) sudo apt install fd-find -y;;
    * ) echo "skipping fd install";;
  esac
}

install_fzf () {
  read -p "Do you want to install fzf? [y/N] " answer
  case "$answer" in
    y|Y )
      echo "export FZF_DEFAULT_COMMAND='fdfind --type f'" >> ~/.bashrc
      echo "export FZF_DEFAULT_OPTS='--height 20% --layout=reverse'" >> ~/.bashrc
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install
      ;;
    * ) echo "skipping fzf install";;
  esac
}


install_rust () {
  read -p "Do you want to install rust? [y/N] " answer
  case "$answer" in
    y|Y ) curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh;;
    * ) echo "skipping rust install";;
  esac
}


the_end () {
  echo 'Type: exec "$SHELL" to reload shell'
  echo "done."
}


main () {
  update_system
  install_neovim
  install_tmux
  setup_bash
  install_pyenv
  # TODO install specific Python version
  # TODO setup general virtualenv:
  #      - ~/.python-version
  #      - neovim packages
  #      - numpy
  #      - matplotlib?
  # TODO setup virtualenv for jupyterlabs?
  install_fdfind
  install_rust
  # TODO zoxide
  # TODO docker
  # TODO multipass
  # TODO elixir
  # TODO install node
  # TODO setup node for neovim
  # TODO phoenix

  the_end
}
main
