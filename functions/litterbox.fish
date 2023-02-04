function litterbox
  curl -F "reqtype=fileupload" -F "time=1h" -F "fileToUpload=@$argv[1]" https://litterbox.catbox.moe/resources/internals/api.php
end

