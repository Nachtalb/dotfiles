function litterbox
  if test -z "$argv[1]"
    echo "Usage: litterbox <file>"
    return 1
  end

  curl -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@$argv[1]" https://litterbox.catbox.moe/resources/internals/api.php
end

