function catbox
  curl -F "reqtype=fileupload" -F "fileToUpload=@$argv[1]" https://catbox.moe/user/api.php
end

