# uninst-pinentry.nsi - Uninstaller snippet.        -*- coding: latin-1; -*-
# Copyright (C) 2007 g10 Code GmbH
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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.


!ifdef prefix
!undef prefix
!endif
!define prefix ${ipdir}/pinentry-${gpg4win_pkg_pinentry_version}


# Uninstaller section.
Section "-un.pinentry"
!ifdef SOURCES
  Push "${gpg4win_pkg_pinentry}"
  Call un.SourceDelete
!else
  Delete "$INSTDIR\bin\pinentry-w32.exe"
  Delete "$INSTDIR\bin\pinentry-gtk-2.exe"
  Delete "$INSTDIR\bin\pinentry-qt.exe"
  Delete "$INSTDIR\bin\pinentry.exe"

  RMDir "$INSTDIR"
!endif
SectionEnd
