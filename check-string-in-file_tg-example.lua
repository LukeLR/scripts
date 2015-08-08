dofile("/usr/share/check-string-in-file.lua") --parse the string reader file

function on_msg_receive (msg)
  if started == 0 then
    return
  end
  if msg.out then
    return
  end
  do_notify (get_title (msg.from, msg.to), msg.text)
  if check("/usr/share/tg-whitelist", tostring(msg.from.id), ' ') == true then
    --code here will be executed if message sender is on whitelist
  end
end
