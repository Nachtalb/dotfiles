set -l cpaste_path ~/.config/fish/bin/cpaste
if not test -f $cpaste_path
  if command -q pbpaste
      set -gx CPASTE "pbpaste"
  else if command -q wl-copy
      set -gx CPASTE "wl-paste"
  else if command -q xclip
      set -gx CPASTE "xclip" "-o" "-sel" "clip"
  else if command -q xsel
      set -gx CPASTE "xsel" "-o" "-b"
  else if command -q lemonade
      set -gx CPASTE "lemonade" "paste"
  else if command -q win32yank.exe
      set -gx CPASTE "win32yank.exe" "-o" "--lf"  # win32yank.exe has about double the performance of powershell.exe -c Get-Clipboard
  else if command -q termunx-clipboard-set
      set -gx CPASTE "termunx-clipboard-set"
  else if command -q powershell.exe
      set -gx CPASTE "powershell.exe" "-c" "Get-Clipboard"
  else if test -n $TMUX; and command -q tmux
      set -gx CPASTE "save-buffer" "-"
  end

  if test (count $CPASTE) = 1
      ln -sf (which $CPASTE) $cpaste_path
    else
      printf "#/usr/bin/env sh\n$CPASTE" > $cpaste_path
      chmod +x $cpaste_path
  end
end

set -l ccopy_path ~/.config/fish/bin/ccopy
if not test -f $ccopy_path
    if command -q pbcopy
        set -gx "CCOPY" "pbcopy"
    else if command -q wl-copy
        set -gx "CCOPY" "wl-copy"
    else if command -q xclip
        set -gx "CCOPY" "xclip" "-sel" "clip"
    else if command -q xsel
        set -gx "CCOPY" "xsel" "-ibs"
    else if command -q lemonade
        set -gx "CCOPY" "lemonade" "copy"
    else if command -q clip.exe
        set -gx "CCOPY" "clip.exe"  # clip.exe has about double the performance of win32yank.exe
    else if command -q win32yank.exe
        set -gx "CCOPY" "win32yank.exe" "-i" "-clrf"
    else if command -q termunx-clipboard-set
        set -gx "CCOPY" "termunx-clipboard-set"
    else if test -n $TMUX; and command -q tmux
        set -gx "CCOPY" "tmux load-buffer -"
    end

    if test (count $CCOPY) = 1
        ln -sf (which $CCOPY) $ccopy_path
      else
        printf "#/usr/bin/env sh\nread | $CCOPY" > $ccopy_path
        chmod +x $ccopy_path
    end
end
