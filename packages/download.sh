#!/bin/sh
# download.sh - Download source and binary packages for GPG4Win.
# Copyright (C) 2005, 2007 g10 Code GmbH
#
# This file is part of Gpg4win.
#
# Gpg4win is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Gpg4win is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA

# Syntax of the packages.current file:
#
# If the first non whitespace character of a line is #, the line is
# considered a comment.  If the first word of a line is "server", the
# rest of the line will be taken as the base URL for following file
# commands.  If the first word of a line is "file" the rest of the
# line will be appended to the current base URL (with a / as
# delimiter). Checksums are sha256 sums.
#
# Example:
#
#    # GnuPG stuff.
#    server ftp://ftp.gnupg.org/gcrypt
#
#    file gnupg/gnupg-1.4.2.tar.gz
#    chk  1e92b39ef4f4cdf3b1849b6f824dd8f160276aa5c9718be35f8a7bd190bf6154
#


usage()
{
    cat <<EOF
Usage: $0 [OPTIONS]
Options:
	[--force]
        [--quiet]
        [--ipv4]
        [--ipv6]
        [--v4] Downlad packages for Version 4.x (default)
        [--v3] Downlad packages for Version 3.x
        [--clean] Do not download but remove downloaded files.
EOF
    exit $1
}


force=no
quiet=no
version3=no
version4=no
ipvx=
clean=no
#keep_list=no
#sig_check=yes
while [ $# -gt 0 ]; do
    case "$1" in
	--*=*)
	    optarg=`echo "$1" | sed 's/[-_a-zA-Z0-9]*=//'`
	    ;;
	*)
	    optarg=""
	    ;;
    esac

    case $1 in
	--force)
	    force=yes
	    ;;
        --keep-list)
            # Now a dummy
            # keep_list=yes
            ;;
        --no-sig-check)
            # Now a dummy
            sig_check=no
            ;;
        --quiet)
            quiet=yes
            ;;
        --ipv4)
            ipvx="-4"
            ;;
        --ipv6)
            ipvx="-6"
            ;;
        --v4)
            version4=yes
            ;;
        --v3)
            version3=yes
            ;;
        --clean)
            clean=yes
            ;;
	*)
	    usage 1 1>&2
	    ;;
    esac
    shift
done


WGET="wget $ipvx"

# We used to download the packages.current list but it turned out that
# this is too problematic: As there is no history of these files it is
# not possible to build and older version of gpg4win using the online
# version of the list.  Thus we keep the list now with the installer
# and in case a package update is required we will post an updated
# list to the mailing list.
#
#url="http://www.gpg4win.org"
#if [ "$keep_list" = "no" ]; then
#  echo "downloading packages list from \`$url'."
#  if ! ${WGET} -N -q $url/packages.current{,.sig} ; then
#      echo "download of packages list failed." >&2
#      exit 1
#  fi
#fi
#
#if [ "$sig_ckeck" = yes ]; then
# if ! gpgv --keyring ./packages.keys packages.current.sig packages.current
#   then
#    echo "list of packages is not usable." >&2
#    exit 1
# fi
#fi

packages="packages.common"

if [ "$version4" = "yes" ] && [ "$version3" = "yes" ]; then
    echo "Invalid arguments. Both -v4 and -v3 set."
    exit 1;
elif [ "$version4" = "yes" ]; then
    echo "Downloading packages for version 4.x"
    rm -f '.#download.v3'
    packages="$packages packages.4"
elif [ "$version3" = "yes" ] || [ -f '.#download.v3' ]; then
    echo "Downloading packages for version 3.x"
    packages="$packages packages.3"
    touch '.#download.v3'
else
    echo "Downloading packages for version 4.x"
    packages="$packages packages.4"
fi


lnr=0
name=
[ $clean = yes ] && rm -f '.#download.v*'
[ -f '.#download.failed' ] && rm '.#download.failed'
cat $packages | \
while read key value ; do
    : $(( lnr = lnr + 1 ))
    [ -z "$key" ] && continue
    case "$key" in
     \#*)    ;;
    server)
       server="$value"
       name=
       ;;
     name)
       if [ -z "$value" ]; then
           echo "syntax error in name statement, line $lnr" >&2
           exit 1
       fi
       name="$value"
       [ $quiet = no ] && echo "using name  \`$name'"
       ;;
    file)
       if [ -z "$value" ]; then
           echo "syntax error in file statement, line $lnr" >&2
           exit 1
       fi
       if [ -z "$server" ]; then
           echo "no server location for file \`$value', line $lnr" >&2
           exit 1
       fi
       url="$server/$value"
       if [ -z "$name" ]; then
           name=`basename "$value"`
       fi

       if [ "$clean" = "yes" ]; then
           [ $quiet = no ] && echo "Removing: $name"
           rm -f $name
       elif [ -s "$name" -a "$force" = "no" ]; then
           [ $quiet = no ] && echo "package     \`$url' ... already exists"
       else
           echo -n "downloading \`$url' ..."
           if ${WGET} -c -q "$url" -O "$name" ; then
               if [ $(stat -c'%s' "$name" 2>/dev/null || echo 0) -eq 0 ]; then
                 echo " FAILED (line $lnr)"
                 echo "line $lnr: $url has zero length" >> '.#download.failed'
               else
                 echo " okay"
               fi
           else
               echo " FAILED (line $lnr)"
               echo "line $lnr: downloading $url failed" >> '.#download.failed'
           fi
       fi
       ;;
    link)
       if [ -z "$value" ]; then
           echo "syntax error in file statement, line $lnr" >&2
           exit 1
       fi
       if [ -z "$name" ]; then
           echo "no name for link in line $lnr" >&2
           exit 1
       fi
       if [ $clean = yes ]; then
           [ $quiet = no ] && echo "Removing link: $name"
           rm -f $name
       elif [ -f "$value" -a "$force" = "no" ]; then
           [ $quiet = no ] && echo "package     \`$value' ... already exists"
       else
           echo -n "linking \`$value' to \`$name' ..."
	   if ln -f "$name" "$value"; then
               echo " okay"
           else
               echo " FAILED (line $lnr)"
               echo "line $lnr: linking $value failed" >> '.#download.failed'
           fi
       fi
       ;;
     chk)
       [ $clean = yes ] && continue
       if [ -z "$value" ]; then
           echo "syntax error in chk statement, line $lnr" >&2
           exit 1
       fi
       if [ -z "$name" ]; then
           echo "no file name for chk statement, line $lnr" >&2
           exit 1
       fi
       [ $quiet = no ] && echo -n "checking    \`$name' ..."
       if echo "$value *$name" | sha256sum -c --status ; then
           [ $quiet = no ] && echo " okay"
       else
           [ $quiet = no ] && echo " FAILED (line $lnr)"
           [ $quiet = no ] || echo "checking    \`$name' FAILED (line $lnr)"
           echo "line $lnr: checking $name failed" >> '.#download.failed'
       fi
       name=
       ;;
     *)
       echo "syntax error in \`packages.current', line $lnr." >&2
       exit 1
     esac
done
if [ -f '.#download.failed' ]; then
  cat '.#download.failed' >&2
  rm '.#download.failed'
  echo "some files failed to download or checksums are not matching" >&2
  exit 1
fi
