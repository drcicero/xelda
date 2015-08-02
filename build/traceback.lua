--- Pretty Traceback

--- Prettier traceback than 'debug.traceback'. 'i' defaults to '1', 'reversed'
-- to 'false'. See for yourself:
--[[
error("CRITICAL FATAL ERROR")
]]
local function traceback (msg, i, reversed)
    if not msg then msg="" end
    if not i then i=1 end
    local trace = {}
    debug.traceback("", 2+i-1)
        :gsub("\t", "  ")
      -- remove 'stack traceback:\n' and the boot.lua line
        :sub(19, -63)
      -- find source line
        :gsub("(.-)\n", function (traceline)
            local locals = " {"
            local i=1
            while true do
                local k, v = debug.getlocal(#trace+5, i)
                if k == nil then
                    break
                elseif tostring(k) ~= "(*temporary)" then
                    if type(v) == "table" then v = "{#" .. #v .. "}"
                    elseif type(v) == "function" then v = "f()"
                    else v = tostring(v):gsub("\n", "\\n") end
                    locals = locals .. tostring(k) .. "=" .. v .. ", "
                end
                i = i+1
            end
            locals = locals .. "}"

            local file, line_num = traceline:match("  (.-):(.-): in .*")
            if file ~= nil and file:sub(1,1) ~= "[" then
                line_num = tonumber(line_num)
                local i = 0
                local ok, lines = pcall(io.lines, file)
                if ok then
                    for line in io.lines(file) do
                        i=i+1
                        if i == line_num then
                            trace[#trace+1] = traceline .. locals ..
                                "\n  = " .. line:match(" *(.*)")
                            return 
                        end
                    end
                end
            end
            trace[#trace+1] = traceline .. locals
        end)

    if reversed then
        local len, rev = #trace, {}
        for i=1,len do rev[len-i+1] = trace[i] end

        return "TRACEBACK (most recent call last):\n"
            .. table.concat(rev, "\n\n") .. "\n\n" .. msg
    end

    return msg .. "\n\nTRACEBACK (most recent call first):\n"
        .. table.concat(trace, "\n\n") .. "\n"
end

return traceback
