# oh-my-fish-config.mac

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
├── browser-sync@2.26.3
└── npm@6.4.1

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
├── npm@6.4.1
├── phantomjs-prebuilt@2.1.14
├── prettier@1.15.1
├── prettier-cli@0.1.0
├── scss-lint@0.0.0
└── whitespace@2.1.0
```

```
$ brew leaves                                                                                    0|14:27:28

antiword            weikengchen/caskformula/inkscape    pygobject3
automake            intltool                            qt
blueutil            jbig2dec                            ranger
boost-build         jpeg-turbo                          rbenv
bzip2               libexif                             redis
ccache              libmagic                            rsync
cmake               libvorbis                           sassc
cmatrix             libvpx                              screenfetch
ctags               libxmlsec1                          shellcheck
direnv              libxslt                             sl
docker              libyaml                             rockymadden/rockymadden/slack-cli
docker-machine      links                               source-highlight
docx2txt            lynx                                speedtest-cli
fdk-aac             makedepend                          task
ffmpeg              mongodb                             telegram-cli
fftw                mysql                               telnet
fontforge           nasm                                texi2html
fswatch             ncdu                                tmux
gawk                neofetch                            toilet
ghostscript         nginx                               tree
giflib              openldap                            ttfautohint
gifsicle            openssl@1.1                         unar
git                 opus                                unrar
git-extras          orc                                 watch
gnu-sed             p7zip                               wget
gnupg               pandoc                              with-readline
go                  perl                                wv
grc                 pipes-sh                            xclip
highlight           postgresql                          yarn
htop                pth                                 youtube-dl
hub                 pup                                 zlib
imagemagick@6       py2cairo

