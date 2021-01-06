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

VIM
---

See [vim/](https://github.com/mupi2k/dotfiles/tree/main/vim/) for details on VIM plugins and configuration

TMUX
----

See [tmux/](https://github.com/mupi2k/dotfiles/tree/main/tmux) for details on tmux and tmate configuration.

Custom Configs
--------------

This dotfiles incorporates custom configs functionality. This is especially powerful for Vim, where your custom config can
control which plugins are loaded or not.  This functionality primarily exists to allow tweaking of settings between machines
(perhaps you want different fonts/colors/prompt on production machines than test/qa?) Simply put the overrides into the
custom-configs folder. Any files ending in .sh will be loaded for bash and zsh; files ending in .zsh will load for zsh only.

This could also be used to allow you to create your own (private) repo to branch off, or to put ssh settings that you probably
don't want to be public.

For example, I have my tmate key loaded via an alias from this folder, so you can't use my tmate API key for your sessions, but
it's easily available to any of mine.

For more details on controlling vim via this mechanism, look at the VIM section above.  Leveraging VIM 8's built-in package
mechanism gives you a LOT of control over which plugins are loaded at runtime, without requireing you to fork (and thus
maintain your own) entire copy of this repo.

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
