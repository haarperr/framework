# Installation
Some assets may not be included in this repository. It is recommended that the missing assets are acquired directly from the server. Otherwise some resources may need to be stopped in `config/resources.cfg`.

The `run.cmd` starts the server. It looks for `FXServer/FXServer.exe` one directory up.

# Project Conventions
**Syntax**
- Use tabs for indentation.
- Use `PascalCasing` for functions or variables outside function scopes.
- Use `camelCasing` inside function scopes.
- Use underscore-prefixed `_camelCasing` for system variables or taken names.
- Use padding inside tables (but not for the keys): `{ [key] = value }`
- Use no padding in string concatenation: `someVar.."my string"`
- Use sentences with stops when writing comments (it will be easier to distinguish from normal code): `-- This is a comment.`

**Resources**
- Prefix client, server, and shared scripts `cl_`, `sv_`, and `sh_`, respectively, followed by the script name, resource name, or `config`.
- Large resources (more than 5 scripts) can be split into folders named `server/*.lua`, `client/*.lua`, and `shared/*.lua` without prefixes.
- Resource categories are wrapped with `[]`.

## Manifest Template
- Use the new version of the manifest file, `fxmanifest.lua`.
```Lua
fx_version 'cerulean'
game 'gta5'

ui_page ''

files {

}

dependencies {
	
}

shared_scripts {
	'sh_config.lua',
	'sh_resourceName.lua',
}

client_scripts {
	'cl_resourceName.lua',
}

server_scripts {
	'sv_resourceName.lua',
}
```

## Comments
- Categorize groups below comments.
```Lua
--[[ Init ]]--
--[[ Functions ]]--
--[[ Threads ]]--
--[[ Events ]]--
```

- Try to annotate code using complete sentences.
```Lua
local source = source

-- Check player is active.
if not self.active[source] then return end

-- Set player no longer active.
self.active[source] = nil
```

## Config

`[category]\resourceName\sh_config.lua`
```Lua
Config = {
	FloatVar = 1.0,
	IntVar = 1,
	TableVar = {
		{ Name = "Test1", OtherVar = true },
		{ Name = "Test2", OtherVar = true },
	},
}
```