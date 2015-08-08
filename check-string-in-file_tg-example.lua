--[[
--** This file is part of LukeLR/scripts.
--**
--** LukeLR/scripts is free software: you can redistribute it and/or
--** modify it under the terms of the cc-by-nc-sa (Creative Commons
--** Attribution-NonCommercial-ShareAlike) as released by the
--** Creative Commons organisation, version 3.0.
--**
--** LukeLR/scripts is distributed in the hope that it will be useful,
--** but without any warranty.
--**
--** You should have received a copy of the cc-by-nc-sa-license along
--** with this copy of LukeLR/scripts. If not, see
--** <https://creativecommons.org/licenses/by-nc-sa/3.0/legalcode>.
--**
--** Copyright Lukas Rose 2015
--]]

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

--add other methods for tg-cli if needed
