const char * const vanilla_files[] =
{
  "../GnuPG/VERSION",
  "../GnuPG/README.txt",
  "../GnuPG/bin/dirmngr.exe",
  "../GnuPG/bin/dirmngr_ldap.exe",
  "../GnuPG/bin/gpg-agent.exe",
  "../GnuPG/bin/gpg-card.exe",
  "../GnuPG/bin/gpg-check-pattern.exe",
  "../GnuPG/bin/gpg-connect-agent.exe",
  "../GnuPG/bin/gpg-preset-passphrase.exe",
  "../GnuPG/bin/gpg-wks-client.exe",
  "../GnuPG/bin/gpg.exe",
  "../GnuPG/bin/gpgconf.exe",
  "../GnuPG/bin/gpgme-w32spawn.exe",
  "../GnuPG/bin/gpgsm.exe",
  "../GnuPG/bin/gpgtar.exe",
  "../GnuPG/bin/gpgv.exe",
  "../GnuPG/bin/keyboxd.exe",
  "../GnuPG/bin/libassuan-0.dll",
  "../GnuPG/bin/libgcrypt-20.dll",
  "../GnuPG/bin/libgpg-error-0.dll",
  "../GnuPG/bin/libgpgme-11.dll",
  "../GnuPG/bin/libksba-8.dll",
  "../GnuPG/bin/libnpth-0.dll",
  "../GnuPG/bin/libsqlite3-0.dll",
  "../GnuPG/bin/pinentry-basic.exe",
  "../GnuPG/bin/scdaemon.exe",
  "../GnuPG/bin/zlib1.dll",
  "../GnuPG/include/assuan.h",
  "../GnuPG/include/gcrypt.h",
  "../GnuPG/include/gpg-error.h",
  "../GnuPG/include/gpgme.h",
  "../GnuPG/include/ksba.h",
  "../GnuPG/include/npth.h",
  "../GnuPG/lib/libassuan.imp",
  "../GnuPG/lib/libgcrypt.imp",
  "../GnuPG/lib/libgpg-error.imp",
  "../GnuPG/lib/libgpgme.imp",
  "../GnuPG/lib/libksba.imp",
  "../GnuPG/lib/libnpth.imp",
  "../GnuPG/share/doc/gnupg/examples/pwpattern.list",
  "../GnuPG/share/gnupg/distsigkey.gpg",
  "../GnuPG/share/gnupg/sks-keyservers.netCA.pem",
  "../GnuPG/share/locale/ca/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/cs/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/cs/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/da/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/da/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/de/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/de/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/el/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/en@boldquot/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/en@quot/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/eo/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/eo/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/es/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/es/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/et/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/fi/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/fr/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/fr/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/gl/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/hu/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/hu/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/id/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/it/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/it/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/ja/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/ja/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/nb/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/nl/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/pl/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/pl/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/pt/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/pt/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/ro/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/ro/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/ru/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/ru/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/sk/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/sr/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/sv/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/sv/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/tr/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/uk/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/uk/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/vi/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/zh_CN/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/zh_CN/LC_MESSAGES/libgpg-error.mo",
  "../GnuPG/share/locale/zh_TW/LC_MESSAGES/gnupg2.mo",
  "../GnuPG/share/locale/zh_TW/LC_MESSAGES/libgpg-error.mo",
  NULL
};
