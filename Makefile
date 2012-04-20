# makefile for md5/sha1 library for Lua

# change these to reflect your Lua installation
LUA= /tmp/lhf/lua-5.0
LUAINC= $(LUA)/include
LUALIB= $(LUA)/lib
LUABIN= $(LUA)/bin

### change these to reflect your MD5 library
MYNAME= md5
#
# MD5 library available in libmd5 -- assumes md5global.h
MD5LIB= -lmd5
MD5INC= .
#
# MD5 library available in libcrypto (openssl)
#	make DEFS=-DUSE_MD5_OPENSSL MD5LIB=-lcrypto
#DEFS= -DUSE_MD5_OPENSSL
#MD5LIB= -lcrypto
#
# Rivest's MD5 library from source -- rename or link global.h as md5global.h
#	make DEFS=-DUSE_MD5_RIVEST MD5LIB=md5c.o
#DEFS= -DUSE_MD5_RIVEST
#MD5LIB= md5c.o
#MD5OBJ= $(MD5LIB)
#
# Deutsch's MD5 library from source
#	make DEFS=-DUSE_MD5_DEUTSCH MD5LIB=md5.o
#DEFS= -DUSE_MD5_DEUTSCH
#MD5LIB= md5.o
#MD5OBJ= $(MD5LIB)
#
# Plumb's MD5 library from source
#	make DEFS=-DUSE_MD5_PLUMB MD5LIB=md5.o
#DEFS= -DUSE_MD5_PLUMB
#MD5LIB= md5.o
#MD5OBJ= $(MD5LIB)

### change these to reflect your SHA1 library
#MYNAME= sha1
#
# SHA1 library available in libcrypto (openssl)
#	make DEFS=-DUSE_SHA1_OPENSSL MD5LIB=-lcrypto MYNAME=sha1
#DEFS= -DUSE_SHA1_OPENSSL
#MD5LIB= -lcrypto
#
# rfc3174 SHA1 library from source
#	make DEFS=-DUSE_SHA1_RFC MD5LIB=sha1.o MYNAME=sha1
#DEFS= -DUSE_SHA1_RFC
#MD5LIB= sha1.o
#MD5OBJ= $(MD5LIB)
#
# skalibs SHA1 SHA1 library from source
#	make DEFS=-DUSE_SHA1_SKALIBS MD5LIB=sha1.o MYNAME=sha1
#DEFS= -DUSE_SHA1_SKALIBS
#MD5LIB= sha1.o
#MD5OBJ= $(MD5LIB)

# no need to change anything below here
CFLAGS= $(INCS) $(DEFS) $(WARN) -O2 $G
WARN= #-ansi -pedantic -Wall
INCS= -I$(LUAINC) -I$(MD5INC)

MYLIB= l$(MYNAME)
T= $(MYLIB).so
OBJS= $(MYLIB).o
TEST= test.lua

all:	test

test:	$T
	$(LUABIN)/lua -l$(MYNAME) $(TEST)

o:	$(MYLIB).o

so:	$T

$T:	$(OBJS) $(MD5OBJ)
	$(CC) -o $@ -shared $(OBJS) $(MD5LIB)

clean:
	rm -f $(OBJS) $T core core.* a.out $(MD5OBJ)

doc:
	@echo "$(MYNAME) library:"
	@fgrep '/**' $(MYLIB).c | cut -f2 -d/ | tr -d '*' | sort | column

# distribution

FTP= $(HOME)/public/ftp/lua
D= $(MYNAME)
A= $(MYLIB).tar.gz
TOTAR= Makefile,README,lmd5.c,lmd5.h,lsha1.c,md5.lua,sha1.lua,test.lua

tar:	clean
	tar zcvf $A -C .. $D/{$(TOTAR)}

distr:	tar
	touch -r $A .stamp
	mv $A $(FTP)

diff:	clean
	tar zxf $(FTP)/$A
	diff $D .

# eof
