# ssh-copy-id will not be installed on OSX so
#
if test ! $(which ssh-copy-id)
then
  echo "Installing ssh-copy-id for you"
  curl -L https://raw.githubusercontent.com/beautifulcode/ssh-copy-id-for-OSX/master/install.sh | sh
fi
