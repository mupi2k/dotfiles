Mike Porter's dotfiles
===============

These are Mike Porter's dotfiles. They personalize things such as aliases, bash
configurations, git prompts, etc. For example, `.bashrc`.


Install
-------

    git clone ssh://git@github.com:7999/mupi2k/dotfiles.git ~.dotfiles
    cd .dotfiles
    ./bootstrap

This will symlink the appropriate files in `.dotfiles` to your home directory.
 - CSH users will need to manually add a couple of tweaks.  If you don't use ClearCase, add:
    alias precmd 'set _exit=$?; set prompt="`$HOME/.promptline2.bash $_exit [**] $WHOAMI ` "; '
to your .cshrc. This will give you almost all of the bash/git goodies in your prompt.
 - You will also need to make sure `$LC_ALL` is set to `en_US.UTF-8` (assuming you are in the US :D )  
    - CSH: `setenv LC_ALL en_US.UTF-8`
    - BASH/ZSH: `export LC_ALL=en_US.UTF-8` 

This dotfiles incorporates the following vim plugins:
  - [promtline](https://github.com/edkolev/promptline.vim) (doesn't require airline, but much more flexible with it)
  - [vim-eunuch](https://github.com/tpope/vim-eunuch) (run Unix commands without leaving vim, especially if you forgot to sudo vim...)
  - [vim-fugitive](https://github.com/tpope/vim-fugitive) (run git commands without leaving vim...)
  - [vim-vinegar](https://github.com/tpope/vim-vinegar) (yes, I like tim pope's things..)
  - [tmuxline](https://github.com/edkolev/tmuxline.vim) (use airline theme for tmux status line, too)
  - [airline](https://github.com/vim-airline/vim-airline) (like promptline, but without running a python daemon)
  - [airline-themes](https://github.com/vim-airline/vim-airline-themes) (themes for airline)

Note that those are NOT loaded as submodules; this means that they will load without fuss or requiring you to use `--recursive` 
  when you git clone this.

Most everything is left at defaults, which allows vimrc to be quite small.

You will probably also want to get the "powerline" fonts for best results.  Those are available at 
https://github.com/powerline/fonts  . Once you download and install those, set your terminal emulator to use those fonts.
Look for 'for powerline' in the font description.

Finally, the `.vim/` loaded here requires a minimum Vim version of 8. On Solaris, you will need to activate vim 8.2, which is in the works.  Eventually I will get things in place to stop trying to load everything, and it will get better.  In the mean time, you can use "vim -u NONE" to skip ~/.vimrc.

This version implements `custom_configs` functionality.  The `custom_configs` directory is ignored by git, so you can safely
put any overrides into that folder, and the .bashrc/.zshrc will pull them in.  You can't really tweak your .vim folder that way, but 
you can add a `custom_configs/` to `~/.dotfiles/vim/vim.symlink/pack/` and Vim 8+ should pick that up. 

For example, if you update your airline theme in vim, and want to update your promptline/tmuxline to match, you can use the promptline commands (see the promptline's documentation for help with this...), you can have promptline write to ~/.dotfiles/custom_config/prompline.sh and bash and zsh will execute it. (you will probably need to re-source those config files to pull in your changes, though)
 
Everything else is configured and tweaked within `~/.dotfiles`.  


Working With VMs?
-----------------

Here's a bonus. Add the following lines to your Vagrantfile provisioning block
and you'll have the same dotfile goodness in your new VM.


    config.vm.provision "setup dotfiles", type: "shell", privileged: false,
        inline: "curl -s 'http://github.com/mupi2k/dotfiles/browse/remoteInstall.sh?at=refs%2Fheads%2Fmaster&raw' | bash -s #{ENV['LOGNAME']} "

What does this do? It is a 'curl pipe' to run the script 'remoteInstall.sh'
currently found in my dotfiles repo and passes in _your_ userid. The script
then clones _your_ dotfiles into the ~vagrant/ directory and installs them
so you can have your .gitconfig, .vimrc, etc and be just as comfortable in
a VM as you are on tuna, slapp69, etc.

Interested in trying out someone else's dotfiles? Remove the .dotfiles directory
**inside the VM** and re-run it like this:

    rm -rf ~/.dotfiles
    curl -s 'http://github.com/mupi2k/dotfiles/browse/remoteInstall.sh?at=refs%2Fheads%2Fmaster&raw' | bash -s mporter

**DANGER** This may wreak havoc if you do this in your real world NFS shared
$HOME directory!! It changes the defaults for the install process to allow
installation without prompting you and backs up all existing dot files.

Also, if the VM doesn't include Git, that will be installed as well. You can thank
me later ;)
