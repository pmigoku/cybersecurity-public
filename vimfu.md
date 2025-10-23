# vimfu

## Neovim - config 
[Neovim](https://neovim.io/doc/) is a modern, highly extensible text editor that is a fork of the popular Vim editor. It retains Vim's core features while improving usability, making it easier to maintain, and enhancing its extensibility through a more modern architecture and better APIs. This allows for advanced user interfaces and a more robust plugin ecosystem, supporting modern languages like Lua for configuration. 

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

## Splits 
View the top 10 lines of your file in the same window.
```
# open viewport with 10 lines of the current file
:10split
# switch between windows
<ctrl>+w
```

## Buffers & Tabs
**Key Concepts:**
- **Buffers**: In-memory representations of files. You can have many buffers open, even if you are only viewing a few at a time.
- **Windows**: Viewports that display the content of a buffer. You can split your screen into multiple windows to view different parts of a file or different files simultaneously.
- **Tabs**: Containers for one or more windows. Each tab can have a unique arrangement of windows.

```
# Buffers
:ls
:buffers
:bnext
:bprev
:buffer n           # Move to (n) buffer

# Tabs
:tabnew file.txt    # Open file.txt in a new tab
:tabclose           # Close the current tab
:tabnext            # Go to next tab
:tabprevious        # Go to previous tab
:tablast            # Go to last tab
:tabfirst           # Go to first tab

# in normal mode
gt  # move forward a tab
gT  # move backward a tab
```


