-- Command handlers

local commands = {}

commands["whitelist"] = function(action, user_id)
    -- Add or remove an user from the whitelist
    if action == "add" then
        add_to_whitelist(user_id)
        return "Added " .. user_id .. " to the whitelist"
    elseif action == "remove" then
        remove_from_whitelist(user_id)
        return "Removed " .. user_id .. " from the whitelist"
    elseif action == "check" then
        -- Check if the user is in the whitelist
        if is_in_whitelist(user_id) then
            return "User " .. user_id .. " is in the whitelist"
        else
            return "User " .. user_id .. " is not in the whitelist"
        end
    end
end

function handle_command(chat_id, command)
    -- Remove the prefix from the command
    command = command:sub(getenv("BOT_PREFIX"):len())

    -- Split in spaces
    local command_args = {}
    for arg in command:gmatch("%S+") do
        table.insert(command_args, arg)
    end

    -- Call the command
    local command_name = command_args[1]
    if not commands[command_name] then
        -- This is probably not a command
        return
    end

    table.remove(command_args, 1)
    local command_result = commands[command_name](unpack(command_args))

    -- Send the result
    API.send_message(chat_id, command_result)

    return true
end