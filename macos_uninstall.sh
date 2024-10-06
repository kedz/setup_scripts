INSTALL_PATH=$HOME/kedz_install

function find_oldest() {
  echo `find -E $1 -maxdepth 1 -type f  -regex ".*/${2}\.[0-9]{14}$" | sort -r | head -n 1`
} 


old_zshrc=$(find_oldest "$HOME" ".zshrc")
if [[ -f "$old_zshrc" ]]; then
    echo "Restoring $old_zshrc"
    mv $old_zshrc $HOME/.zshrc

  elif [[ -f "$HOME/.zshrc" ]]; then
    echo "Uninstalling $HOME/.zshrc"
    rm $HOME/.zshrc
fi

old_zprofile=$(find_oldest "$HOME" ".zprofile")
if [[ -f "$old_zprofile" ]]; then
  echo "Restoring $old_zprofile"
  mv $old_zprofile $HOME/.zprofile
elif [[ -f "$HOME/.zprofile" ]]; then
  echo "Uninstalling $HOME/.zprofile"
  rm $HOME/.zprofile
fi

old_p10k=$(find_oldest "$HOME" ".p10k.zsh")
if [[ -f "$old_p10k" ]]; then
  echo "Restoring $old_p10k"
  mv $old_p10k $HOME/.p10k.zsh
elif [[ -f "$HOME/.p10k.zsh" ]]; then
  echo "Uninstalling $HOME/.p10k.zsh"
  rm $HOME/.p10k.zsh
fi

rm -rf $INSTALL_PATH

if [[ -d $HOME/.kedz_config/nvim ]]; then
  echo "rm -rf $HOME/.kedz_config/nvim"
  rm -rf $HOME/.kedz_config/nvim
fi

if [ "$ZSH" = "$INSTALL_PATH/oh-my-zsh" ]; then
    unset ZSH
  else
    echo "oh-my-zsh already uninstalled."
fi

exec zsh
