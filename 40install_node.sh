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

#download and extract desired node.js version
OUT=$( [ ! -d "/opt/elasticbeanstalk/node-install" ] && mkdir /opt/elasticbeanstalk/node-install ; cd /opt/elasticbeanstalk/node-install/ && wget -nc http://nodejs.org/dist/v$NODE_VER/node-v$NODE_VER-linux-$ARCH.tar.gz && tar --skip-old-files -xzpf node-v$NODE_VER-linux-$ARCH.tar.gz) || error_exit "Failed to UPDATE node version. $OUT" $?.
echo $OUT

#make sure node binaries can be found globally
rm -f /usr/bin/node
ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/node /usr/bin/node

rm -f /opt/elasticbeanstalk/node-install/current
ln -s /opt/elasticbeanstalk/node-install/node-v$NODE_VER-linux-$ARCH/bin/ /opt/elasticbeanstalk/node-install/current

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
