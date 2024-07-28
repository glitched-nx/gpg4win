# Copyright (C) 2024 g10 Code GmbH
#
# This file is part of GPG4Win.
#
# GPG4Win is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# GPG4Win is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
!ifdef prefix
!undef prefix
!endif
!define prefix ${ipdir}/breeze-${gpg4win_pkg_breeze_version}

Section "-breeze" SEC_breeze
  SetOutPath "$INSTDIR\bin\styles"
  File ${prefix}/lib/plugins/styles/breeze6.dll
  SetOutPath "$INSTDIR\share\kstyle\themes"
  File ${prefix}/share/kstyle/themes/breeze.themerc
  SetOutPath "$INSTDIR\share\color-schemes"
  File ${prefix}/share/color-schemes/BreezeClassic.colors
  File ${prefix}/share/color-schemes/BreezeLight.colors
  File ${prefix}/share/color-schemes/BreezeDark.colors
SectionEnd
