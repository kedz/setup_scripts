INSTALL_PATH=$HOME/kedz_install

if [ "$ZSH" != "$INSTALL_PATH/oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    ZSH=$INSTALL_PATH/oh-my-zsh sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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
else
    echo "poetry installed: `poetry --version`"
fi

# TODO install poetry plugin for ohmyzsh
# TODO install conda plugin for ohmyzsh
# TODO install p10k theme
