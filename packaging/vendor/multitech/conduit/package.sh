#!/bin/env bash

PACKAGE_NAME="lora-gateway-bridge"
PACKAGE_VERSION="3.0.0-test.3"
REV="r1"


PACKAGE_URL="https://artifacts.loraserver.io/downloads/lora-gateway-bridge/lora-gateway-bridge_${PACKAGE_VERSION}_linux_armv5.tar.gz"
DIR=`dirname $0`
PACKAGE_DIR="${DIR}/package"

# Cleanup
rm -rf $PACKAGE_DIR

# CONTROL
mkdir -p $PACKAGE_DIR/CONTROL
cat > $PACKAGE_DIR/CONTROL/control << EOF
Package: $PACKAGE_NAME
Version: $PACKAGE_VERSION-$REV
Architecture: arm926ejste
Maintainer: Orne Brocaar <info@brocaar.com>
Priority: optional
Section: network
Source: N/A
Description: LoRa Gateway Bridge
EOF

cat > $PACKAGE_DIR/CONTROL/postinst << EOF
update-rc.d lora-gateway-bridge defaults
EOF
chmod 755 $PACKAGE_DIR/CONTROL/postinst

cat > $PACKAGE_DIR/CONTROL/conffiles << EOF
/var/config/$PACKAGE_NAME/$PACKAGE_NAME.toml
EOF

# Files
mkdir -p $PACKAGE_DIR/opt/$PACKAGE_NAME
mkdir -p $PACKAGE_DIR/var/config/$PACKAGE_NAME
mkdir -p $PACKAGE_DIR/etc/init.d

cp files/$PACKAGE_NAME.toml $PACKAGE_DIR/var/config/$PACKAGE_NAME/$PACKAGE_NAME.toml
cp files/$PACKAGE_NAME.init $PACKAGE_DIR/etc/init.d/$PACKAGE_NAME
wget -P $PACKAGE_DIR/opt/$PACKAGE_NAME $PACKAGE_URL
tar zxf $PACKAGE_DIR/opt/$PACKAGE_NAME/*.tar.gz -C $PACKAGE_DIR/opt/$PACKAGE_NAME
rm $PACKAGE_DIR/opt/$PACKAGE_NAME/*.tar.gz

# Package
opkg-build -o root -g root $PACKAGE_DIR

# Cleanup
rm -rf $PACKAGE_DIR
