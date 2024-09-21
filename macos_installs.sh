INSTALL_PATH=$HOME/kedz_install

NO_EXEC=false

for arg in "$@" ; do
  echo "${arg}"
  if [ $arg = "--no-exec" ]; then
    NO_EXEC=true
  fi
done

if [ "$ZSH" != "$INSTALL_PATH/oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    ZSH=$INSTALL_PATH/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/conda-incubator/conda-zsh-completion $INSTALL_PATH/oh-my-zsh/custom/plugins/conda-zsh-completion
    cp zsh_configs/.zshrc $HOME/.zshrc
    source $HOME/.zshrc
    echo "oh-my-zsh installed: $ZSH"
else
    echo "oh-my-zsh installed: $ZSH"
fi

if [ "`which brew`" = "brew not found" ]; then
    echo "Installing brew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo `/opt/homebrew/bin/brew shellenv` >> $HOME/.zprofile
    source $HOME/.zprofile
    echo "brew installed: `brew --version`"
else
    echo "brew installed: `brew --version`"
fi

if [ "`which conda`" = "conda not found" ]; then
    echo "Installing miniconda..."
    MINICONDA_INSTALLER=Miniconda3-latest-MacOSX-arm64.sh
    MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh
    curl -o $MINICONDA_INSTALLER -s $MINICONDA_URL 
    bash $MINICONDA_INSTALLER -u -b -p $INSTALL_PATH/miniconda3
    rm $MINICONDA_INSTALLER
    $INSTALL_PATH/miniconda3/bin/conda init zsh
    source $HOME/.zshrc
    echo "conda installed: `conda --version`"
else
    echo "conda installed: `conda --version`"
fi

# Install poetry
if [ "`which poetry`" = "poetry not found" ]; then
    echo "Installing poetry..."
    curl -sSL https://install.python-poetry.org | POETRY_HOME=$INSTALL_PATH/poetry python3 -

    echo "export PATH=\"/Users/Alix/kedz_install/poetry/bin:\$PATH\"" > $HOME/.zprofile
    source $HOME/.zprofile
    echo "poetry installed: `poetry --version`"
    mkdir $INSTALL_PATH/oh-my-zsh/custom/plugins/poetry
    poetry completions zsh > $ZSH_CUSTOM/plugins/poetry/_poetry
else
    echo "poetry installed: `poetry --version`"
fi

# Install p10k theme.
if [ ! -f ~/.p10k.zsh ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $INSTALL_PATH/oh-my-zsh/custom/themes/powerlevel10k
    cp zsh_configs/.p10k.zsh $HOME/.p10k.zsh
    echo "P10k theme installed."
else
    echo "P10k theme installed."
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

if ! grep -q XDG_CONFIG_HOME ~/.zshrc; then
    echo "export XDG_CONFIG_HOME=\$HOME/.kedz_config" >> ~/.zshrc
    echo "Setting XDG_CONFIG_HOME=$HOME/.kedz_config"
else
    echo "Set XDG_CONFIG_HOME=$HOME/.kedz_config"
fi

# Install neovim config.
if [ ! -d $HOME/.kedz_config/nvim ]; then
    mkdir -p $HOME/.kedz_config
    cp -r nvim $HOME/.kedz_config/
    echo "Installing nvim configs to $HOME/.kedz_config/nvim"
fi

if [ "$NO_EXEC" = false ]; then
  echo "Executing zsh"
  exec zsh
fi
