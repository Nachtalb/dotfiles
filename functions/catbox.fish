function catbox
  if test -z "$argv[1]"
    echo "Usage: catbox <file>"
    return 1
  end

  curl -F "reqtype=fileupload" -F "fileToUpload=@$argv[1]" https://catbox.moe/user/api.php
end

