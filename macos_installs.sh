INSTALL_PATH=$HOME/kedz_install

NO_EXEC=false

for arg in "$@" ; do
  echo "${arg}"
  if [ $arg = "--no-exec" ]; then
    NO_EXEC=true
  fi
done

if [[ -f $HOME/.zshrc ]]; then
  mv $HOME/.zshrc $HOME/.zshrc.`date +%Y%m%d%H%M%S`
fi

if [[ ! -d "$INSTALL_PATH/oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh..."
    ZSH=$INSTALL_PATH/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # We're going to copy config over anyway.
    rm $HOME/.zshrc
    echo "oh-my-zsh installed."
else
    echo "oh-my-zsh installed."
fi

cp zsh_configs/.zshrc $HOME/.zshrc

if [[ ! -x $INSTALL_PATH/miniconda3/bin/conda ]]; then
    echo "Installing miniconda..."
    MINICONDA_INSTALLER=Miniconda3-latest-MacOSX-arm64.sh
    MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
    curl -o $MINICONDA_INSTALLER -s $MINICONDA_URL 
    bash $MINICONDA_INSTALLER -u -b -p $INSTALL_PATH/miniconda3
    rm $MINICONDA_INSTALLER

    $INSTALL_PATH/miniconda3/bin/conda init zsh
    source $HOME/.zshrc
    echo "conda installed to: $INSTALL_PATH/miniconda3"
else
    echo "conda installed to: $INSTALL_PATH/miniconda3"
fi

if [[ -f $HOME/.zprofile ]]; then
  zprofile_backup=$HOME/.zprofile.`date +%Y%m%d%H%M%S`
  echo "Backing up $HOME/.zprofile to $zprofile_backup"
  mv $HOME/.zprofile $zprofile_backup
fi
echo "Creating new $HOME/.zprofile"
echo "# Kedz Setup Script" > $HOME/.zprofile

if [[ -f $HOME/.p10k.zsh ]]; then
  mv $HOME/.p10k.zsh $HOME/.p10k.zsh.`date +%Y%m%d%H%M%S`
fi
cp zsh_configs/.p10k.zsh $HOME/.p10k.zsh

if [[ ! -d $INSTALL_PATH/oh-my-zsh/custom/plugins/conda-zsh-completion ]]; then
  git clone https://github.com/conda-incubator/conda-zsh-completion $INSTALL_PATH/oh-my-zsh/custom/plugins/conda-zsh-completion
else 
    "Echo installing conda-zsh-completion plugin"
fi

if [[ ! -d $INSTALL_PATH/oh-my-zsh/custom/themes/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $INSTALL_PATH/oh-my-zsh/custom/themes/powerlevel10k
  echo "P10k theme installed."
else
  echo "P10k theme installed."
fi

if [ "`which brew`" = "brew not found" ]; then
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    echo `/opt/homebrew/bin/brew shellenv` >> $HOME/.zprofile
    source $HOME/.zprofile
    echo "brew installed: `brew --version`"

else

    if [ ! "`grep HOMEBREW_PREFIX ~/.zprofile`" ]; then
      PATH=$(echo "$PATH" | sed -e 's/\/opt\/homebrew\/bin://')
      PATH=$(echo "$PATH" | sed -e 's/\/opt\/homebrew\/sbin://')
      echo "Adding homebrew to .zprofile"
      echo `/opt/homebrew/bin/brew shellenv` >> $HOME/.zprofile
      source $HOME/.zprofile
    fi
    echo "brew installed: `brew --version`"
fi

# Install poetry
if [[ ! -d $INSTALL_PATH/poetry ]]; then
  echo "Installing poetry..."
  curl -sSL https://install.python-poetry.org | POETRY_HOME=$INSTALL_PATH/poetry python3 -

  echo "export PATH=\"$INSTALL_PATH/poetry/bin:\$PATH\"" >> $HOME/.zprofile
  echo "poetry installed to: $INSTALL_PATH/poetry"
else

  if [ ! "`grep poetry ~/.zprofile`" ]; then
    echo "export PATH=\"$INSTALL_PATH/poetry/bin:\$PATH\"" >> $HOME/.zprofile
  fi
  echo "poetry installed: $INSTALL_PATH/poetry"
fi

if [[ ! -d $INSTALL_PATH/oh-my-zsh/custom/plugins/poetry ]]; then
  mkdir $INSTALL_PATH/oh-my-zsh/custom/plugins/poetry
  $INSTALL_PATH/poetry/bin/poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
  echo "Installed poetry zsh completions."
else
  echo "Already installed poetry zsh completions."
fi

# Install ripgrep
if [ "`which rg`" = "rg not found" ]; then
    brew install ripgrep
    echo `rg --version`
else
    echo `rg --version`
fi

# Install neovim
if [ "`which nvim`" = "nvim not found" ]; then
    brew install neovim
    echo `nvim --version`
else
    echo `nvim --version`
fi

# Install nvm
if [ "`which nvm`" = "nvm not found" ]; then
    brew install nvm
    source $(brew --prefix nvm)/nvm.sh
    echo `nvm --version`
    if [ ! "`grep -q nvm.sh ~/.zprofile`" ]; then
        echo "source $(brew --prefix nvm)/nvm.sh" >> ~/.zprofile
    fi
else
    echo "nvm version: `nvm --version`"
fi

# Install node.js and npm
if [ "`which node`" = "node not found" ]; then
    nvm install --lts
    echo "node version: `node --version`"
    echo "npm version: `npm --version`"
else
    echo "node version: `node --version`"
    echo "npm version: `npm --version`"
fi

if ! grep -q XDG_CONFIG_HOME ~/.zprofile; then
  echo "export XDG_CONFIG_HOME=\$HOME/.kedz_config" >> ~/.zprofile
  echo "Setting XDG_CONFIG_HOME=$HOME/.kedz_config"
else
  echo "Set XDG_CONFIG_HOME=$HOME/.kedz_config"
fi
if ! grep -q XDG_DATA_HOME ~/.zprofile; then
  echo "export XDG_DATA_HOME=\$HOME/kedz_install/nvim" >> ~/.zprofile
  echo "Setting XDG_DATA_HOME=$HOME/kedz_install/nvim"
else
  echo "Set XDG_DATA_HOME=$HOME/kedz_install/nvim"
fi

#Install neovim config.
if [ ! -d $HOME/.kedz_config/nvim ]; then
    mkdir -p $HOME/.kedz_config
    cp -r nvim $HOME/.kedz_config/
    echo "Installing nvim configs to $HOME/.kedz_config/nvim"
fi

cp zsh_configs/aliases.zsh $INSTALL_PATH/oh-my-zsh/custom/

if [ ! -d $INSTALL_PATH/fonts ]; then
    git clone https://github.com/powerline/fonts.git --depth=2 $INSTALL_PATH/fonts
    bash $INSTALL_PATH/fonts/install.sh
    echo "Installed powerline fonts."
fi

if [ "$NO_EXEC" = false ]; then
  echo "Executing zsh"
  exec zsh
fi
