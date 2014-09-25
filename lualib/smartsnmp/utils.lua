------------------------------------------------------------------------------
-- getopt_alt.lua from http://lua-users.org/wiki/AlternativeGetOpt

-- getopt, POSIX style command line argument parser
-- param arg contains the command line arguments in a standard table.
-- param options is a string with the letters that expect string values.
-- returns a table where associated keys are true, nil, or a string value.
-- The following example styles are supported
--   -a one  ==> opts["a"]=="one"
--   -bone   ==> opts["b"]=="one"
--   -c      ==> opts["c"]==true
--   --c=one ==> opts["c"]=="one"
--   -cdaone ==> opts["c"]==true opts["d"]==true opts["a"]=="one"
-- note POSIX demands the parser ends at the first non option
--      this behavior isn't implemented.
------------------------------------------------------------------------------

local utils = {}

utils.getopt = function (arg, options)
  local tab = {}
  for k, v in ipairs(arg) do
    if string.sub( v, 1, 2) == "--" then
      local x = string.find( v, "=", 1, true )
      if x then tab[ string.sub( v, 3, x-1 ) ] = string.sub( v, x+1 )
      else      tab[ string.sub( v, 3 ) ] = true
      end
    elseif string.sub( v, 1, 1 ) == "-" then
      local y = 2
      local l = string.len(v)
      local jopt
      while ( y <= l ) do
        jopt = string.sub( v, y, y )
        if string.find( options, jopt, 1, true ) then
          if y < l then
            tab[ jopt ] = string.sub( v, y+1 )
            y = l
          else
            tab[ jopt ] = arg[ k + 1 ]
          end
        else
          tab[ jopt ] = true
        end
        y = y + 1
      end
    end
  end
  return tab
end

-----------------------------------------
-- convert oid string to oid lua table
-----------------------------------------
utils.str2oid = function (s)
    local oid = {}
    for n in string.gmatch(s, '%d+') do
        table.insert(oid, tonumber(n))
    end
    return oid
end

local hexval = function(x)
    if x >= string.byte('0') and x <= string.byte('9') then
        return x - string.byte('0')
    elseif x >= string.byte('a') and x <= string.byte('f') then
        return x - string.byte('a') + 10
    elseif x >= string.byte('A') and x <= string.byte('F') then
        return x - string.byte('A') + 10
    else
        assert(0)
    end
end

------------------------------------------
-- convert physical address to string 
------------------------------------------
utils.mac2str = function(mac)
    assert(type(mac) == 'string')
    local s = {}
    for i = 1, #mac, 2 do
        table.insert(s, string.char(hexval(string.byte(mac, i)) * 16 + hexval(string.byte(mac, i + 1))))
    end
    return table.concat(s)
end

return utils
