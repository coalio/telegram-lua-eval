-- env.lua
-- Function that replaces os.getenv with a function that
-- also takes the .env file in account

if not _G['__env'] then
    _G['__env'] = {}
    local env = {}
    local env_file = io.open(".env", "r")

    if not env_file then
        -- Search for a .env file in the outer directories
        for depth = 1, ENV_MAX_DEPTH do
            env_file = io.open(string.format('%s.env', ('../'):rep(depth)), 'r')
            if env_file then
                break
            end
        end
    end

    if env_file then
        for line in env_file:lines() do
            local key, value = line:match("^%s*([%w_][%w_%d]-)=(.*)")
            if key and value then
                env[key] = value
            end
        end

        env_file:close()
    end

    _G['__env'] = env

    _G['getenv'] = function(key)
        return _G['__env'][key] or os.getenv(key)
    end
end