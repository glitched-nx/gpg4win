#!/bin/sh
# Build an AppImage of GnuPG (VS-)Desktop
# Copyright (C) 2021, 2024 g10 Code GmbH
#
# Software engineering by: Ingo Klöcker <dev@ingo-kloecker.de>
#                          Andre Heinecke <aheinecke@gnupg.org>
# This file is part of GnuPG.
#
# GnuPG is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# GnuPG is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <https://www.gnu.org/licenses/>.
#
# SPDX-License-Identifier: GPL-3.0+

set -e

BUILDROOT=/build
SRCDIR=${BUILDROOT}/src
APPDIR=${SRCDIR}/playground/AppDir
INSTDIR=${SRCDIR}/playground/install
VSD_DIR=${SRCDIR}/gnupg-vsd

cd ${BUILDROOT}
# Check for the buildtype and existence of required files
# early
BUILDTYPE=$(cat ${BUILDROOT}/packages/BUILDTYPE || echo default)
if [ $BUILDTYPE != default ] && [ ! -f ${SRCDIR}/gnupg-vsd/custom.mk ]; then
    echo "ERROR: Non default build without custom file."
    echo "Check that src/gnupg-vsd/custom.mk exists or "
    echo "change the BUILDTYPE in packages/BUILDTYPE"
    exit 2
fi
if [ $BUILDTYPE vsd ] && \
    [ ! -f ${SRCDIR}/gnupg-vsd/Standard/VERSION ]; then
    echo "No VERSION file in Standard dir."
    exit 2
fi
if [ $BUILDTYPE gpd ] && \
    [ ! -f ${SRCDIR}/gnupg-vsd/Desktop/VERSION ]; then
    echo "No VERSION file in Desktop dir."
    exit 2
fi

# The actual build
./autogen.sh --force
./configure --enable-appimage --enable-maintainer-mode
make

echo 'rootdir = $APPDIR/usr' >${APPDIR}/usr/bin/gpgconf.ctl
if [ $BUILDTYPE = vsd ]; then
    echo 'sysconfdir = /etc/gnupg-vsd' >>${APPDIR}/usr/bin/gpgconf.ctl
else
    echo 'sysconfdir = /etc/gnupg' >>${APPDIR}/usr/bin/gpgconf.ctl
fi

# Copy the start-shell helper for use AppRun
cp ${SRCDIR}/appimage/start-shell ${APPDIR}/
chmod +x ${APPDIR}/start-shell

# Copy standard global configuration
if [ $BUILDTYPE = vsd ]; then
    mkdir -p ${APPDIR}/usr/share/gnupg/conf/gnupg-vsd
    rsync -aLv --delete --omit-dir-times \
          ${SRCDIR}/gnupg-vsd/Standard/etc/gnupg/ \
          ${APPDIR}/usr/share/gnupg/conf/gnupg-vsd/
fi

export PATH=/opt/linuxdeploy/usr/bin:$PATH
export LD_LIBRARY_PATH=${INSTDIR}/lib:${INSTDIR}/lib64

# tell the linuxdeploy qt-plugin where to find qmake
export QMAKE=${INSTDIR}/bin/qmake

# create plugin directories expected by linuxdeploy qt-plugin
# workaround for
# [qt/stdout] Deploy[qt/stderr] terminate called after throwing an instance of 'boost::filesystem::filesystem_error'
# [qt/stderr]   what():  boost::filesystem::directory_iterator::construct: No such file or directory: "/build/AppDir/usr/plugins/sqldrivers"
# ERROR: Failed to run plugin: qt (exit code: 6)
mkdir -p ${INSTDIR}/plugins/sqldrivers

# copy KDE plugins
for d in kiconthemes6 kf6 pim6; do
    mkdir -p ${APPDIR}/usr/plugins/${d}/
    rsync -av --delete --omit-dir-times ${INSTDIR}/lib64/plugins/${d}/ ${APPDIR}/usr/plugins/${d}/
done
mkdir -p ${APPDIR}/usr/plugins/okular_generators/

mkdir -p ${APPDIR}/usr/lib
# copy okular generator plugins and dependcies
# okularGenerator_*.so
cp -av ${INSTDIR}/lib/libfreetype* ${APPDIR}/usr/lib
# okularGenerator_poppler.so
cp -av ${INSTDIR}/lib64/libpoppler* ${APPDIR}/usr/lib
cp -av ${INSTDIR}/lib64/plugins/okular_generators/okularGenerator_poppler.so ${APPDIR}/usr/plugins/okular_generators/

# copy other libraries that are loaded dynamically
mkdir -p ${APPDIR}/usr/lib
cp -av ${INSTDIR}/lib64/libOkular6Core.so* ${APPDIR}/usr/lib

cd /build
# Remove existing AppRun and wrapped AppRun, that may be left over
# from a previous run of linuxdeploy, to ensure that our custom AppRun
# is deployed
rm -f ${APPDIR}/AppRun ${APPDIR}/AppRun.wrapped 2>/dev/null
# Remove existing translations that may be left over from a previous
# run of linuxdeploy
rm -rf ${APPDIR}/usr/translations
# Remove the version files to make sure that only one will be created.
rm -f ${APPDIR}/GnuPG-VS-Desktop-VERSION 2>/dev/null
rm -f ${APPDIR}/GnuPG-Desktop-VERSION    2>/dev/null
rm -f ${APPDIR}/Gpg4win-VERSION        2>/dev/null

myversion=$(grep PACKAGE_VERSION ${SRCDIR}/../config.h|sed -n 's/.*"\(.*\)"$/\1/p')
if [ $BUILDTYPE = vsd ]; then
    OUTPUT=gnupg-vs-desktop-${myversion}-x86_64.AppImage
    echo "Packaging GnuPG VS-Desktop Appimage: $myversion"
    echo $myversion >${APPDIR}/GnuPG-VS-Desktop-VERSION
    cp ${VSD_DIR}/Standard/VERSION* ${APPDIR}/usr/
    echo "Packaging help files"
    mkdir -p ${APPDIR}/usr/share/doc/gnupg-vsd
    cp ${VSD_DIR}/help/*.pdf ${APPDIR}/usr/share/doc/gnupg-vsd
    if [ -f ${VSD_DIR}/Standard/kleopatrarc ]; then
        echo "Packaging kleopatrarc"
        mkdir -p ${APPDIR}/usr/etc/xdg
        cp ${VSD_DIR}/Standard/kleopatrarc ${APPDIR}/usr/etc/xdg
    fi
elif [ $BUILDTYPE = gpd ]; then
    OUTPUT=gnupg-desktop-${myversion}-x86_64.AppImage
    echo "Packaging GnuPG Desktop Appimage: $myversion"
    echo $myversion >${APPDIR}/GnuPG-Desktop-VERSION
    cp ${VSD_DIR}/Desktop/VERSION* ${APPDIR}/usr/
    echo "Packaging help files"
    mkdir -p ${APPDIR}/usr/share/doc/gnupg-vsd
    cp ${VSD_DIR}/help/*.pdf ${APPDIR}/usr/share/doc/gnupg-vsd
    if [ -f ${VSD_DIR}/Desktop/kleopatrarc ]; then
        echo "Packaging kleopatrarc"
        mkdir -p ${APPDIR}/usr/etc/xdg
        cp ${VSD_DIR}/Desktop/kleopatrarc ${APPDIR}/usr/etc/xdg
    fi
else
    OUTPUT=gpg4win-${myversion}-x86_64.AppImage
    echo "Packaging Gpg4win Appimage: $myversion"
    echo $myversion >${APPDIR}/Gpg4win-VERSION
fi
export OUTPUT

# Hack around that linuxdeploy does not know libexec
for f in dirmngr_ldap gpg-check-pattern \
         gpg-preset-passphrase gpg-protect-tool \
         gpg-wks-client scdaemon \
         keyboxd gpg-pair-tool; do
# Ignore errors because some files might not exist depending
# on GnuPG Version
    /opt/linuxdeploy/usr/bin/patchelf \
              --set-rpath '$ORIGIN/../lib' ${APPDIR}/usr/libexec/$f || true
done

# linuxdeploy also doesn't know about non-Qt plugins
for f in $(find ${APPDIR}/usr/plugins/ -mindepth 1 -maxdepth 1 -type f); do
    # Okularpart
    /opt/linuxdeploy/usr/bin/patchelf --set-rpath '$ORIGIN/../../lib' $
done
for f in $(find ${APPDIR}/usr/plugins/ -mindepth 2 -maxdepth 2 -type f); do
    /opt/linuxdeploy/usr/bin/patchelf --set-rpath '$ORIGIN/../../../lib' $f
done
for f in $(find ${APPDIR}/usr/plugins/ -mindepth 3 -maxdepth 3 -type f); do
    /opt/linuxdeploy/usr/bin/patchelf --set-rpath '$ORIGIN/../../../../lib' $f
done

# Fix up everything and build the file system
linuxdeploy --appdir ${APPDIR} \
            --desktop-file ${APPDIR}/usr/share/applications/org.kde.kleopatra.desktop \
            --icon-file ${APPDIR}/usr/share/icons/hicolor/256x256/apps/kleopatra.png \
            --custom-apprun ${SRCDIR}/appimage/AppRun \
            --plugin qt \
            --output appimage \
    2>&1 | tee /build/logs/linuxdeploy-gnupg-desktop.log

echo ready
exit 0
