-- md5.lua
-- support code for md5 library
-- usage lua -lmd5 ...

local function so(x)
	local SOPATH= os.getenv"LUA_SOPATH" or "./"
	assert(loadlib(SOPATH.."l"..x..".so","luaopen_"..x))()
end

so"md5"
