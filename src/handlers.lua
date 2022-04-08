-- handlers.lua
-- Specify your handlers here, they will be loaded automatically.

local on_message = require('src.handlers.on_message')

HANDLERS = {
    ['on_message'] = on_message
}