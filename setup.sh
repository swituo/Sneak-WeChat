#!/bin/bash

CURR_DIR=`dirname $0`
cd ${CURR_DIR}
CURR_DIR=`pwd`

TEMP_PATH="${CURR_DIR}/temp_$(date | md5sum | awk '{print substr($1,1,10);}')"
mkdir -p ${TEMP_PATH}

# download ver 2.1.4
rm -f weixin_2.1.4_amd64.deb
wget https://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.4_amd64.deb

# download ver 2.1.8 (latest)
rm -f weixin_2.1.8_amd64.deb
wget http://archive2.kylinos.cn/deb/kylin/production/PART-V10-SP1/custom/partner/V10-SP1/pool/all/weixin_2.1.8_amd64.deb

# install ver 2.1.8
dpkg -i weixin_2.1.8_amd64.deb

# v2.1.8 files
cp -r /opt/weixin/locales ${TEMP_PATH}/
cp -r /opt/weixin/resources ${TEMP_PATH}/

# uninstall ver 2.1.8
dpkg -r --purge weixin

# isntall ver 2.1.4
dpkg -i weixin_2.1.4_amd64.deb

# backup v2.1.4 files
rm -rf /opt/weixin/locales.v214
rm -rf /opt/weixin/resources.v214
mv /opt/weixin/locales /opt/weixin/locales.v214
mv /opt/weixin/resources /opt/weixin/resources.v214

# copy v2.1.8 files to /opt/weixin/
cp -r ${TEMP_PATH}/locales /opt/weixin/
cp -r ${TEMP_PATH}/resources /opt/weixin/resources


# backup UOS activation
cp /usr/lib/libactivation.so .


exit

# rewrite /etc/lsb-release
sudo cp /etc/lsb-release /etc/lsb-release.bak
sudo cat > /etc/lsb-release << EOF
DISTRIB_ID=Kylin
DISTRIB_RELEASE=V10
DISTRIB_CODENAME=kylin
DISTRIB_DESCRIPTION="Kylin V10 SP1"
DISTRIB_KYLIN_RELEASE=V10
DISTRIB_VERSION_TYPE=enterprise
DISTRIB_VERSION_MODE=normal
EOF
