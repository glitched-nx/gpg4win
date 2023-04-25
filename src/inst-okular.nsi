# Copyright (C) 2023 g10 Code GmbH
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
!define prefix ${ipdir}/okular-${gpg4win_pkg_okular_version}

# Okular - Opt in for now.
${MementoUnselectedSection} "Okular (experimental)" SEC_okular

  SetOutPath "$INSTDIR\bin"
  File ${prefix}/bin/okular.exe
  File ${prefix}/bin/libOkular5Core.dll
  SetOutPath "$INSTDIR\bin\plugins\okular\generators"
#  File ${prefix}/plugins/okular/generators/okularGenerator_fb.dll
#  File ${prefix}/plugins/okular/generators/okularGenerator_comicbook.dll
#  File ${prefix}/plugins/okular/generators/okularGenerator_kimgio.dll
#  File ${prefix}/plugins/okular/generators/okularGenerator_dvi.dll
#  File ${prefix}/plugins/okular/generators/okularGenerator_txt.dll
#  File ${prefix}/plugins/okular/generators/okularGenerator_fax.dll
  File ${prefix}/lib/plugins/okular/generators/okularGenerator_poppler.dll
#  File ${prefix}/plugins/okular/generators/okularGenerator_xps.dll
  SetOutPath "$INSTDIR\bin\plugins"
  File ${prefix}/lib/plugins/okularpart.dll


  SetOutPath "$INSTDIR\share\icons\hicolor\128x128\apps"

  File ${prefix}/share/icons/hicolor/128x128/apps/okular.png

  SetOutPath "$INSTDIR\share\icons\hicolor\16x16\apps"

  File ${prefix}/share/icons/hicolor/16x16/apps/okular.png

  SetOutPath "$INSTDIR\share\icons\hicolor\22x22\apps"

  File ${prefix}/share/icons/hicolor/22x22/apps/okular.png

  SetOutPath "$INSTDIR\share\icons\hicolor\32x32\apps"

  File ${prefix}/share/icons/hicolor/32x32/apps/okular.png

  SetOutPath "$INSTDIR\share\icons\hicolor\48x48\apps"

  File ${prefix}/share/icons/hicolor/48x48/apps/okular.png

  SetOutPath "$INSTDIR\share\icons\hicolor\64x64\apps"

  File ${prefix}/share/icons/hicolor/64x64/apps/okular.png

  WriteRegStr SHCTX "Software\RegisteredApplications" "Gpg4win.Okular" "SOFTWARE\Gpg4win\Okular\Capabilities"
  WriteRegStr SHCTX "Software\Gpg4win\Okular" "" "Okular"
  WriteRegStr SHCTX "Software\Gpg4win\Okular\Capabilities\FileAssociations" ".pdf" "gpg4win.AssocFile.Okular.PDF"
  WriteRegStr SHCTX "Software\Gpg4win\Okular\Capabilities\MimeAssociations" "application/pdf" "gpg4win.AssocFile.Okular.PDF"
  WriteRegStr SHCTX "Software\Gpg4win\kleopatra\Capabilities" "ApplicationDescription" "$(DESC_SEC_okular)"
  WriteRegStr SHCTX "Software\Gpg4win\kleopatra\Capabilities" "ApplicationIcon" "$INSTDIR\bin\okular.exe,0"
  WriteRegStr SHCTX "Software\Gpg4win\kleopatra\Capabilities" "ApplicationName" "Okular"

  WriteRegExpandStr SHCTX "Software\Classes\gpg4win.AssocFile.Okular.PDF\shell\open\command" "" "$\"$INSTDIR\bin\Okular.exe$\" -- $\"%1$\""
  WriteRegStr SHCTX "Software\Classes\gpg4win.AssocFile.Okular.PDF\CurVer" "" "${VERSION}"
  # TODO need to generate a icon from application-pdf
  WriteRegStr SHCTX "Software\Classes\gpg4win.AssocFile.Okular.PDF\DefaultIcon" "" "$INSTDIR\share\gpg4win\file-ext.ico"

${MementoSectionEnd}

LangString DESC_SEC_okular ${LANG_ENGLISH} \
   "A high security PDF reader to sign and verify pdf documents with GnuPG."

LangString DESC_Menu_okular ${LANG_ENGLISH} \
   "Run the Okular PDF viewer to sign and verify documents with GnuPG."
