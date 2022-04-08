-- main.lua
-- Initial bot setup

API = require('telegram-bot-lua.core').configure(
    getenv('BOT_TOKEN')
)

-- Load handlers
require('src.handlers')
for event, handler in pairs(HANDLERS) do
    API[event] = handler
end

-- You're done!
API.run()