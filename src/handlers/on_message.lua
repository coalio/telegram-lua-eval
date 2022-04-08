-- on_message.lua
-- Handler for the on_message event.

local prefix = getenv("BOT_PREFIX")

function validate_prefix(text)
    -- Check that "text" starts with the prefix
    if not text:match("^" .. prefix .. "%s") then
        return false
    end

    return true
end

function get_code_snippet(text)
    -- Get the code snippet from the text
    -- The code snippet comes either after the prefix or between ```
    local code_snippet =
        text:match("^" .. prefix .. "%s(.*)$") or text:match("`-(.+)`-")

    if not code_snippet then
        return nil
    end

    return code_snippet
end

function execute_in_sandbox(code)
    -- Run in the sandbox
    local ok, result = pcall(sandbox.run, code, {
        quota = tonumber(getenv("BOT_QUOTA")),
        env = { print = buffered_print }
    })

    if not ok then
        -- If the sandbox failed, print the error
        WARN:log(result)
        return result
    end

    INFO:log("Executed " .. code:len() .. " bytes")

    return result
end

return function(message)
    if not message.text or message.is_bot or not is_in_whitelist(message.from.id) then
        -- skip
        return
    end

    local user_identifier = message.from.username or message.from.first_name

    -- Log the message
    INFO:log("Query @" .. user_identifier)

    -- Check if the message starts with the prefix
    if not validate_prefix(message.text) then
        -- skip
        return
    end

    -- Attempt to handle command
    -- If the result is true, this was a valid command and was handled correctly
    -- If the result is false, this is not a valid command, so we attempt to
    -- evaluate it as lua code
    if handle_command(message.chat.id, message.text) then
        -- skip
        return
    end

    -- Get the code snippet
    local code_snippet = get_code_snippet(message.text)

    if not code_snippet then
        -- skip
        INFO:log("No code snippet found in query by user @" .. user_identifier)
        return
    end

    -- Execute the code snippet in a sandbox
    INFO:log("Executing query provided by @" .. user_identifier)

    local returned_value = tostring(execute_in_sandbox(code_snippet))
    local stdout_buffer = pop_print_buffer()

    if stdout_buffer:len() > getenv("BOT_MAX_OUTPUT_LENGTH") + 0 then
        stdout_buffer = stdout_buffer:sub(1, getenv("BOT_MAX_OUTPUT_LENGTH")) .. "..."
    end

    if returned_value:len() > getenv("BOT_MAX_OUTPUT_LENGTH") + 0 then
        returned_value = returned_value:sub(1, getenv("BOT_MAX_OUTPUT_LENGTH")) .. "..."
    end

    -- Build and send the output
    local output =
        stdout_buffer .. "\n" ..
        (returned_value ~= "nil" and "[return] " .. returned_value or "")

    API.send_message(
        message.chat.id,
        "```lua\n" .. output:gsub("`", "") .. "\n```",
        "Markdown",
        true,
        true,
        message.message_id
    )

    INFO:log("Finished query from @" .. user_identifier)
end