# telegram-lua-eval

A bot that allows you to run sandboxed Lua code from within Telegram.

## Installation

First, make sure you're using Lua 5.3 or later.

Install `telegram-bot-lua@latest` for Lua 5.3 using luarocks:

```
luarocks install telegram-bot-lua
```

Copy the `.env.sample` into a `.env` file and fill in the values.

```
cp .env.sample .env
```

Then, run the bot:

```
lua bot.lua
```
