-- log.lua
-- Utility library for logging.

local colors = require('src.colors')

local log_prototype = {
    -- Log a message to the console.
    log = function(self, message)
        print(
            self.prefix_color .. self.prefix .. '\x1b[0m' ..
            self.color .. message .. '\x1b[0m' ..
            self.suffix_color .. self.suffix .. '\x1b[0m'
        )
    end,

    -- Set the prefix.
    set_prefix = function(self, prefix)
        self.prefix = prefix or self.prefix
    end,

    -- Set the suffix.
    set_suffix = function(self, suffix)
        self.suffix = suffix or self.suffix
    end,

    -- Set the prefix color.
    set_prefix_color = function(self, color)
        self.prefix_color = colors[color] or color or self.prefix_color
    end,

    -- Set the suffix color.
    set_suffix_color = function(self, color)
        self.suffix_color = colors[color] or color or self.suffix_color
    end,

    -- Set the color.
    set_color = function(self, color)
        self.color = colors[color] or color or self.color
    end,

    prefix = '[LOG]',
    prefix_color = '\x1b[36m',
    color = '\x1b[32m',
    suffix_color = '\x1b[36m',
    suffix = '',
}

-- Return a new log object using log_prototype as metatable
return function(prefix_color, prefix, suffix_color, suffix, color)
    local new_obj = setmetatable({}, {__index = log_prototype})
    new_obj:set_prefix_color(prefix_color)
    new_obj:set_prefix(prefix)
    new_obj:set_suffix_color(suffix_color)
    new_obj:set_suffix(suffix)
    new_obj:set_color(color)

    -- Return the constructed object
    return new_obj
end