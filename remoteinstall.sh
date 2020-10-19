#!/bin/bash -e

cd $HOME

if [ -d .dotfiles ]
then
  echo Dotfiles initialized. You are good to go
  exit 0
fi

# install git if needed
hash git > /dev/null 2>&1 || {
  echo installing git - you can thank me later
  ( sudo apt-get install -y git || sudo yum install -y git ) > /dev/null 2>&1
  echo done installing git
}

userid="${1:-mupi2k}"
rm -f  /tmp/readme
if [ -n "$userid" ]
then
  repo="http://github.com/~$userid"
  curl -so /tmp/readme "http://github.com/users/$userid/repos/dotfiles/browse/README.md?at=refs%2Fheads%2Fmaster&raw"
fi

if [ ! -s /tmp/readme ]
then
   echo; echo
   echo "No 'README.md' found in http://github.com/users/$userid/repos/dotfiles"
   echo "  Maybe you need to enable public access?"
   echo "  Using a generic set of dotfiles."
   echo
   repo="http://github.com/mupi2k"
fi

echo cloning from $repo/dotfiles.git

git clone $repo/dotfiles.git .dotfiles > /dev/null 2>&1
chown --reference=. .dotfiles
cd .dotfiles

echo Initial creation of dotfiles, so modifying initialization to overwrite all ...
cp bootstrap init 2>/dev/null || cp install init 2>/dev/null || true
if [ -s init ]
then
  perl -pi -e 's|backup_all=false|backup_all=true|' init
  ./init || echo "Something went wrong during initialization. You're on your own now"
  rm init
else
  echo "Hmmm - your dotfiles repostiory has no bootstrap / install script. Bailing out"
fi
