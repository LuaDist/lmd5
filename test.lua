-- test md5 library

if md5 then
 KNOWN="f6ad58224a015825d7bb3cb953239f01"
 COMMAND="echo -en 'md5sum\t'; md5sum "
else
 md5=sha1
 KNOWN="d1f1133ee1093f164391b89bf9cefb2a34b9a557"
 COMMAND="echo -en 'sha1sum\t'; sha1sum "
end

print(md5.version)
print""

function report(w,s,F)
 print(w,s.."  "..F)
 assert(s==KNOWN)
end

F="md5.lua"

assert(io.input(F))
report("all",md5.digest(io.read"*a"),F)

assert(io.input(F))
d=md5.new()
while true do
 local c=io.read(1)
 if c==nil then break end
 d:update(c)
end
report("loop",d:digest(),F)
report("again",d:digest(),F)

assert(io.input(F))
d:reset()
while true do
 local c=io.read(math.random(1,16))
 if c==nil then break end
 d:update(c)
end
report("reset",d:digest(),F)

os.execute(COMMAND..F)
report("known",KNOWN,F)

print""
print(md5.version)
