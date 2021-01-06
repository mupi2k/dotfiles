VIM Configuration
=================

Plugins:
--------

The following plugins are always loaded:
  - [vim-sensible](https://github.com/tpope/vim-sensible) Sensible defaults from Tim Pope
  - [vim-vinegar](https://github.com/tpope/vim-vinegar) Use Vim's built-in file manager instead of NERDtree
  - [vim-hug-neovim-rpc](https://github.com/roxma/vim-hug-neovim-rpc) Implement neovim RPC calls for Vim 8.
  - [nvim-yarp](https://github.com/roxma/nvim-yarp) Yet Another Remote Plugin framework.

The last two are required for some of the optional plugins below.  If you really want no plugins loaded, run vim
with `vim --no-plugins` to suppress loading any plugins; you can then manually load plugins individually with
`:packadd <package>` (Vim will still *find* your plugins when run with `--no-plugins`; it just doesn't load them)

The following plugins are loaded by default:
  - [promtline](https://github.com/edkolev/promptline.vim) (doesn't require airline, but much more flexible with it)
  - [vim-eunuch](https://github.com/tpope/vim-eunuch) (run Unix commands without leaving vim, especially if you forgot to sudo vim...)
  - [vim-fugitive](https://github.com/tpope/vim-fugitive) (run git commands without leaving vim...)
  - [vim-vinegar](https://github.com/tpope/vim-vinegar) (yes, I like tim pope's things..)
  - [tmuxline](https://github.com/edkolev/tmuxline.vim) (use airline theme for tmux status line, too)
  - [airline](https://github.com/vim-airline/vim-airline) (like promptline, but without running a python daemon)
  - [airline-themes](https://github.com/vim-airline/vim-airline-themes) (themes for airline)

Note that those are NOT loaded as submodules; this means that they will load without fuss or requiring you to use `--recursive`
  when you git clone this.

Many things are left at defaults, which allows vimrc to be quite small, but there are quite a few things loaded from
config directories, which belies the simplicity of the vimrc itself.

You will probably also want to get the "powerline" fonts for best results.  Those are available at
https://github.com/powerline/fonts  . Once you download and install those, set your terminal emulator to use those fonts.
Look for 'for powerline' in the font description.

Finally, the `.vim/` loaded here requires a minimum Vim version of 8. On Solaris, you will need to activate vim 8.2, which is in the works.  Eventually I will get things in place to stop trying to load everything, and it will get better.  In the mean time, you can use "vim -u NONE" to skip ~/.vimrc.

This version implements `custom-configs` functionality.  The `custom_configs` directory is ignored by git, so you can safely
put any overrides into that folder, and the .bashrc/.zshrc will pull them in.  You can't really tweak your .vim folder that way, but
you can add a `custom-configs/` to `~/.dotfiles/vim/vim.symlink/pack/` and Vim 8+ should pick that up.

For example, if you update your airline theme in vim, and want to update your promptline/tmuxline to match, you can use the promptline commands (see the promptline's documentation for help with this...), you can have promptline write to ~/.dotfiles/custom_config/prompline.sh and bash and zsh will execute it. (you will probably need to re-source those config files to pull in your changes, though)

