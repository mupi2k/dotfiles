Ralph Mike Porter's dotfiles
===============

These are Mike Porter's dotfiles. They personalize things such as aliases, bash
configurations, git prompts, etc. For example, `.bashrc`.


Install
-------

    git clone ssh://git@stash.csw.l-3com.com:7999/~u155484/dotfiles.git ~.dotfiles
    cd .dotfiles
    ./bootstrap

This will symlink the appropriate files in `.dotfiles` to your home directory.
CSH users will need to manually add a couple of tweaks.  If you don't use ClearCase, add:
    alias precmd 'set _exit=$?; set prompt="`$HOME/.promptline2.bash $_exit [**] $WHOAMI ` "; '
to your .cshrc. This will give you almost all of the bash/git goodies in your prompt.
If you _do_ use ClearCase, use:
    alias precmd 'set _exit=$?; set noglob; set ct_pwv=(`ct pwv`); set prompt="`$HOME/.promptline2.bash $_exit [$ct_pwv[4]] $WHOAMI ` "; unset ct_pwv; unset noglob'
instead.  This will give you the same thing, with the additional benefit that ClearCase views will show up as git branches, with [CC] in front of the branch symbol.
You will also need to add 
    setenv LC_ALL en_US.UTF-8 
(BASH users should use
    export LC_ALL=en_US.UTF-8
instead) to get the extra characters to display.

You will probably also want to get the "powerline" fonts for best results.  Those are available at 
https://github.com/powerline/fonts  . Once you download and install those, set your terminal emulator to use those fonts.

Finally, the .vimrc loaded here requires a minimum Vim version of 8. On Solaris, you will need to activate vim 8.2, which is in the works.  Eventually I will get things in place to stop trying to load everything, and it will get better.  In the mean time, you can use "vim -u NONE" to skip ~/.vimrc.

Everything else is configured and tweaked within `~/.dotfiles`.


Working With VMs?
-----------------

Here's a bonus. Add the following lines to your Vagrantfile provisioning block
and you'll have the same dotfile goodness in your new VM.


    config.vm.provision "setup dotfiles", type: "shell", privileged: false,
        inline: "curl -s 'http://bitbucket.csw.l-3com.com/users/u155484/repos/dotfiles/browse/remoteInstall.sh?at=refs%2Fheads%2Fmaster&raw' | bash -s #{ENV['LOGNAME']} "

What does this do? It is a 'curl pipe' to run the script 'remoteInstall.sh'
currently found in my dotfiles repo and passes in _your_ userid. The script
then clones _your_ dotfiles into the ~vagrant/ directory and installs them
so you can have your .gitconfig, .vimrc, etc and be just as comfortable in
a VM as you are on tuna, slapp69, etc.

Interested in trying out someone else's dotfiles? Remove the .dotfiles directory
**inside the VM** and re-run it like this:

    rm -rf ~/.dotfiles
    curl -s 'http://bitbucket.csw.l-3com.com/users/u155484/repos/dotfiles/browse/remoteInstall.sh?at=refs%2Fheads%2Fmaster&raw' | bash -s mporter

**DANGER** This may wreck havoc if you do this in your real world NFS shared
$HOME directory!! It changes the defaults for the install process to allow
installation without prompting you and backs up all existing dot files.

Also, if the VM doesn't include Git, that will be installed as well. You can thank
me later ;)
