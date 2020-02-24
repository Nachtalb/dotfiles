# Nachtalbs Dotfiles

Create default home structure and symlinks by running `init_home.py` with Python3.

Install:
```
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -L https://get.oh-my.fish | fish
find ~/.gnupg -type d -exec chmod 700 {} \;
find ~/.gnupg -type f -exec chmod 600 {} \;
chmod 600 ~/.ssh/id_rsa
```

---

```
$ screenfetch

                 -/+:.          bernd@bernd
                :++++.          OS: 64bit Mac OS X 10.14.5 18F132
               /+++/.           Kernel: x86_64 Darwin 18.6.0
       .:-::- .+/:-``.::-       Uptime: 51m
    .:/++++++/::::/++++++/:`    Packages: 373
  .:///////////////////////:`   Shell: fish 3.0.2-903-g2ca1bc43
  ////////////////////////`     Resolution: 2880x1800
 -+++++++++++++++++++++++`      DE: Aqua
 /++++++++++++++++++++++/       WM: Quartz Compositor
 /sssssssssssssssssssssss.      WM Theme: Blue
 :ssssssssssssssssssssssss-     CPU: Intel Core i7-4870HQ @ 2.50GHz
  osssssssssssssssssssssssso/`  GPU: AMD Radeon R9 M370X / Intel Iris Pro
  `syyyyyyyyyyyyyyyyyyyyyyyy+`  RAM: 7341MiB / 16384MiB
   `ossssssssssssssssssssss/
     :ooooooooooooooooooo+.
      `:+oo+/:-..-:/+o+/-
```

```
$ nvm use v8.14.0
$ npm ls -g --depth=0
/Users/bernd/.nvm/versions/node/v8.14.0/lib
├── @marp-team/marp-cli@0.0.15
├── browser-sync@2.26.3
├── eslint@5.16.0
├── nativefier@7.6.12
├── npm@6.7.0
└── prettier@1.18.2


$ nvm use system
$ npm ls -g --depth=0
/usr/local/lib
├── @vue/cli@3.1.1
├── bower@1.8.4
├── browser-sync@2.26.3
├── eslint@4.19.1
├── eslint-config-airbnb-base@13.0.0
├── eslint-plugin-import@2.13.0
├── fkill@5.3.0
├── fkill-cli@5.0.0
├── gif-cli@1.2.9
├── git-open@2.0.0
├── grunt@1.0.3
├── markdown-toc@1.2.0
├── npm@6.9.0
├── phantomjs-prebuilt@2.1.14
├── prettier@1.15.1
├── prettier-cli@0.1.0
├── scss-lint@0.0.0
└── whitespace@2.1.0
```

```
$ brew leaves | to-cols -n 4

antiword           fswatch         makedepend      shellcheck
astyle             fzf             mandoc          sl
atool              fzy             media-info      rockymadden/rockymadden/slack-cli
autoconf-archive   gawk            mongodb         source-highlight
automake           gdl             nasm            speedtest-cli
blueutil           giflossy        ncdu            sphinx
boost-build        gifsicle        neofetch        task
bzip2              git             nginx           telegram-cli
ccache             git-extras      nnn             telnet
cmake              gnu-sed         octave          texi2html
cmatrix            gnupg           openldap        the_silver_searcher
cowsay             go              openssl@1.1     tmux
cscope             grc             orc             toilet
ctags              groff           p7zip           transmission
dash               gsl             pacvim          tree
dialog             gtkmm           pandoc          ttfautohint
direnv             gtkmm3          pipes-sh        unar
dmenu              highlight       popt            unrar
docker             htop            postgresql      veclibfort
docker-machine     hub             postgresql@10   vim
docx2txt           imagemagick@6   potrace         w3m
doxygen            irssi           pth             watch
elasticsearch      jbig2dec        pup             wget
elinks             jpeg-turbo      pygobject3      with-readline
exiftool           libexif         ranger          wv
extract_url        libsoup         rbenv           xclip
fdk-aac            libxmlsec1      rdfind          yarn
fdupes             libxslt         redis           youtube-dl
ffmpeg             links           rsync           zegervdv/zathura/zathura-pdf-poppler
fontforge          little-cms      sassc           zenity
fortune            lua@5.1         sc-im           zlib
```
