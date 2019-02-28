# Nachtalbs Dotfiles

Create default home structure and symlinks by running `init_home.py` with Python3.

Install pyenv:
```
$ curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
```


---

```
$ screenfetch

                 -/+:.          bernd@bernd
                :++++.          OS: 64bit Mac OS X 10.13.6 17G4015
               /+++/.           Kernel: x86_64 Darwin 17.7.0
       .:-::- .+/:-``.::-       Uptime: 3d 9h 37m
    .:/++++++/::::/++++++/:`    Packages: 248
  .:///////////////////////:`   Shell: fish i
  ////////////////////////`     Resolution: 1920x1200 1920x1200
 -+++++++++++++++++++++++`      DE: Aqua
 /++++++++++++++++++++++/       WM: Quartz Compositor
 /sssssssssssssssssssssss.      WM Theme: Blue
 :ssssssssssssssssssssssss-     Font: SFMono-Regular
  osssssssssssssssssssssssso/`  CPU: Intel Core i7-4870HQ @ 2.50GHz
  `syyyyyyyyyyyyyyyyyyyyyyyy+`  GPU: AMD Radeon R9 M370X / Intel Iris Pro
   `ossssssssssssssssssssss/    RAM: 8203MiB / 16384MiB
     :ooooooooooooooooooo+.
      `:+oo+/:-..-:/+o+/-
```

```
$ nvm use v8.14.0
$ npm ls -g --depth=0
/Users/bernd/.nvm/versions/node/v8.14.0/lib
├── @marp-team/marp-cli@0.0.15
├── browser-sync@2.26.3
└── npm@6.7.0

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
├── npm@6.5.0
├── phantomjs-prebuilt@2.1.14
├── prettier@1.15.1
├── prettier-cli@0.1.0
├── scss-lint@0.0.0
└── whitespace@2.1.0
```

```
$ brew leaves | to-cols -n 4

antiword           gifsicle        media-info    shellcheck
atool              git             mongodb       sl
autoconf-archive   git-extras      nasm          rockymadden/rockymadden/slack-cli
automake           gnu-sed         ncdu          source-highlight
blueutil           gnupg           neofetch      speedtest-cli
boost-build        go              nginx         sphinx
bzip2              grc             openldap      sphinx-doc
ccache             groff           openssl@1.1   task
cmake              gsl             orc           telegram-cli
cmatrix            gtkmm           p7zip         telnet
ctags              gtkmm3          pandoc        texi2html
direnv             highlight       perl          the_silver_searcher
docker             htop            pipes-sh      tmux
docker-machine     hub             poppler       toilet
docx2txt           imagemagick@6   popt          transmission
doxygen            intltool        postgresql    tree
elasticsearch      jbig2dec        potrace       ttfautohint
elinks             jpeg-turbo      pth           unar
exiftool           libexif         pup           unrar
fdk-aac            libmagic        py2cairo      w3m
ffmpeg             libsoup         pygobject3    watch
fftw               libxmlsec1      ranger        wget
fontforge          libxslt         rbenv         with-readline
fswatch            links           redis         wv
gawk               little-cms      rsync         xclip
gdl                lynx            ruby          yarn
ghostscript        makedepend      sassc         youtube-dl
giflossy           mandoc          screenfetch   zlib
```
