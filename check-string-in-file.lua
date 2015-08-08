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

-- checks if file exists. Returns boolean true or false.
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- reads all lines from a file given by path. Result is returned as a table.
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

--[[
--** This function splits a given string, which is passed as
--** str into substrings. The separating character is given
--** as pat. The substrings are returned as a table.
--]]
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

--[[
--** this function reads a table of string lines (read from
--** the text file in this case), and cuts out the comments 
--** which may be included in the line after a seperator Char.
--** The seperator char that splits the lines in arguments and
--** comments is passed as 'separator'. It returns a table of
--** all the arguments that were included in the lines (any text
--** in each line until an instance of 'separator' occurs).
--]]
function extract(lines, separator)
  local result = {}
  for k,v in pairs(lines) do
    local splitted = split(v, separator)
    result[k] = splitted[1]
  end
  while (not lines[count] == nil) do
    local splitted = Split(lines[count], separator)
    result[pos] = splitted[1]
    pos = pos + 1
    count = count + 1
  end
  return result
end

--[[
--** This is the actual main function. It will check if a given
--** string is included in a file specified by file path. Only
--** the first argument in each line of the text file will be
--** read, anything else that follows in that line is treated
--** as a comment and will be ignored. The char passed as
--** 'separator' defines where the argument ends and the comment
--** starts. It will return a Boolean true or false whether the
--** string was included in the file or not.
--]]
function check(file, string, separator)
  for k,v in pairs(extract(lines_from(file), separator)) do
    if v == string then
      print(file, " contains ", string, "!")
      return true
    end
  end
  print(file, " does not contain ", string, "!")
  return false
end
