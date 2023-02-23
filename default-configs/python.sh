if [[ pyenv ]]; then
  # Pyenv Setup <<1
  PATH=~/.pyenv/shims:$PATH
  LDFLAGS="-L/usr/local/opt/zlib/lib"  # hack for install on Mojave
  CPPFLAGS="-I/usr/local/opt/zlib/include"  # hack for install on Mojave
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  # >>1

  #===============================================================================
  # Workon virtualenv <<1
  #--------------------------------------------------------------------
  # If we cd into a directory that is named the same as a virtualenv
  # auto activate that virtualenv
  # -------------------------------------------------------------------

  export PYENV_VIRTUALENV_DISABLE_PROMPT=1

  function check_parent() {
    local check_dir=${1##*/}
    if [ "$1" = "/" ]; then
      pyenv deactivate > /dev/null 2>&1
      echo -n ""
      return 0
    elif [[ -a ~/.pyenv/versions/$check_dir ]]; then
      pyenv deactivate > /dev/null 2>&1
      pyenv activate ${1##*/}
      return 0
    else
      check_parent $( echo $1 |  awk -F '/' '{ if (NF <= 2) printf("%s", "/");for (i = 2; i < NF ; i++) {printf("/%s",$i);} print "";}')
    fi
    return 0
  }

  workon_virtualenv() {
    VENV_CUR="${PWD##*/}"
    if [[ -a ~/.pyenv/versions/$VENV_CUR ]]; then
      pyenv deactivate > /dev/null 2>&1
      pyenv activate $VENV_CUR
    else
      check_parent $( echo $PWD | awk -F '/' '{ if (NF <= 2) printf("%s", "/");for (i = 2; i < NF ; i++) {printf("/%s",$i);} print "";}')
    fi
  }
  # >>1
  #===============================================================================
  # Run the vir tual environments functions for the prompt on each cd <<1
  # -------------------------------------------------------------------
  cd() {
    builtin cd "$@"
    workon_virtualenv
  }
  # >>2


  # Create a virtual environment using pyenv
  # -------------------------------------------------------------------
  mkvirtualenv() {
      pyenv virtualenv $1 $2
      pyenv activate $2
      deactivate() {
          pyenv deactivate $(basename ${VIRTUAL_ENV})
      }
  }
  # >>2

  # Activate a virtualenv using pyenv
  # -------------------------------------------------------------------
  workon() {
      pyenv activate $1
      deactivate() {
          pyenv deactivate $(basename ${VIRTUAL_ENV})
      }
  }
  # >>2

  # change the current directory to the site packages of the currently activated virtualenv
  # -------------------------------------------------------------------
  cdsitepackages() {
      cd ${VIRTUAL_ENV}/lib/python*/site-packages
  }
  # >>2

  # delete the chosen virtualenv
  # -------------------------------------------------------------------
  rmvirtualenv() {
      pyenv uninstall $1
  }
  # >>1
fi
# vim: set foldmarker=<<,>> foldlevel=0 foldmethod=marker:
