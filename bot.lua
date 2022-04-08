-- Set up the bot
require('src.macros')
require('src.env')
require('src.whitelist')
require('src.command')
require('src.print_buffer')

sandbox = require('src.sandbox')

local log = require('src.log')

-- Create log levels
DEBUG = log(
    'white', '[DEBUG] '
);
INFO = log(
    'blue', '[INFO] '
);
WARN = log(
    'yellow', '[WARN] '
);
ERROR = log(
    'red', '[ERROR] '
);

-- Start main.lua in a coroutine
local main = coroutine.create(function()
    require('src.main')
end)

-- Start the main loop
INFO:log("Bot started")

local success, err = coroutine.resume(main)
while true do
    -- Resume the main loop
    if not success then
        -- If the main loop failed, print the error and restart it
        ERROR:log(err)
        main = coroutine.create(function()
            require('src.main')
        end)
    else
        -- If the main loop finished, exit the program
        if coroutine.status(main) == 'dead' then
            break
        end
    end
end