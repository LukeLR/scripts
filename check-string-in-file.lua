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

-- checks if file contains string. only first argument in each line is checked, seperated by space (seperator)

function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  local pos = 1
  for line in io.lines(file) do
    lines[pos] = line
    pos = pos+1
  end
  return lines
end

-- print all line numbers and their contents (debug purposes)
function printtable(lines)
  for k,v in pairs(lines) do
    print('line[' .. k .. ']', v)
  end
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function extract(lines, seperator)
  local result = {}
  for k,v in pairs(lines) do
    local splitted = split(v, ' ')
    result[k] = splitted[1]
  end
  while (not lines[count] == nil) do
    local splitted = Split(lines[count], ' ')
    result[pos] = splitted[1]
    pos = pos + 1
    count = count + 1
    print ("test")
  end
  return result
end

function check(file, string, seperator)
  for k,v in pairs(extract(lines_from(file))) do
    if v == string then
      print(file, " contains ", string, "!")
      return true
    end
  end
  print(file, " does not contain ", string, "!")
  return false
end
