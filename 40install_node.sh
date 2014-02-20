#!/bin/bash
#source env variables including node version
. /opt/elasticbeanstalk/env.vars

function error_exit
{
  eventHelper.py --msg "$1" --severity ERROR
  exit $2
}

#UNCOMMENT to update npm, otherwise will be updated on instance init or rebuild
#rm -f /opt/elasticbeanstalk/node-install/npm_updated

rm -f /usr/bin/npm
ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/npm /usr/bin/npm

if [ ! -f "/opt/elasticbeanstalk/node-install/npm_updated" ]; then
  if [ -d "/opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/" ]; then
    /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/npm update npm -g
  fi
  touch /opt/elasticbeanstalk/node-install/npm_updated
  echo "YAY! Updated global NPM version to `npm -v`"
else
  echo "Skipping NPM -g version update. To update, please uncomment 40install_node.sh:12"
fi
