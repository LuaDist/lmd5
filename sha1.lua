-- sha1.lua
-- support code for sha1 library
-- usage lua -lsha1 ...

local function so(x)
	local SOPATH= os.getenv"LUA_SOPATH" or "./"
	assert(loadlib(SOPATH.."l"..x..".so","luaopen_"..x))()
end

so"sha1"
