-- Whitelist handlers

-- Open whitelist.txt, create it if it doesn't exist
whitelist_handle = io.open('whitelist.txt', 'a+')

whitelist = {}
function load_whitelist()
    whitelist = {}
    whitelist_handle:seek('set', 0)

    for line in whitelist_handle:lines() do
        table.insert(whitelist, line)
    end
end

load_whitelist()

-- Function that adds a user to the whitelist
function add_to_whitelist(user)
    -- Check if the user is already in the whitelist
    if not is_in_whitelist(user) then
        -- Add the user to the whitelist
        whitelist_handle:write(user .. '\n')
        whitelist_handle:flush()
    end

    -- Reload the whitelist
    load_whitelist()
end

-- Function that removes a user from the whitelist
function remove_from_whitelist(user)
    -- Check if the user is in the whitelist
    if is_in_whitelist(user) then
        -- Remove the user from the whitelist
        for i, v in ipairs(whitelist) do
            if v == user then
                table.remove(whitelist, i)
                break
            end
        end
        whitelist_handle:truncate()
        for i, v in ipairs(whitelist) do
            whitelist_handle:write(v .. '\n')
        end
        whitelist_handle:flush()
    end

    -- Reload the whitelist
    load_whitelist()
end

-- Function that checks if a user is in the whitelist
function is_in_whitelist(user)
    -- Check if the user is in the whitelist
    for i, v in ipairs(whitelist) do
        if v:match(user) then
            return true
        end
    end
    return false
end