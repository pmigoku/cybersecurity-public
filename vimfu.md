# vimfu

## nvim - config 
```bash
mkdir $HOME/.config/nvim
vim $HOME/.config/nvim/init.vim
```

Make nvim the default editor
```
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 100
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 100
```
Set env variables in .bashrc
```
export EDITOR=nvim
export VISUAL=nvim
```

View the top 10 lines of your file in the same window.
```
# open viewport with 10 lines of the current file
:10split
# switch between windows
<ctrl>+w
```
