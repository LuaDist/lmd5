# Copyright (C) 2012 LuaDist.
# Created by David Manura
# Redistribution and use of this file is allowed according to the terms of the MIT license.
# For details see the COPYRIGHT file distributed with LuaDist.
# Please note that the package source code is licensed under its own license.

project ( lmd5 C )
cmake_minimum_required ( VERSION 2.6 )
include ( cmake/dist.cmake )
include ( lua )

# Locate OpenSSL crypto library.
find_package ( OpenSSL REQUIRED )
message("i ${OPENSSL_INCLUDE_DIR} ${OPENSSL_CRYPTO_LIBRARY}")
include_directories ( "${OPENSSL_CRYPTO_LIBRARY}" )
include ( CheckIncludeFiles )
check_include_files ( openssl/md2.h HAS_MD2 )

# lists of digests to support
set ( digests md4 md5 sha1 sha224 sha256 sha384 sha512 ripemd160 )
if ( HAS_MD2 )
  set ( digests ${digests} md2 )
endif ()
message ( "digests:${digests}" )

# Define a module for each supported digest.
foreach ( digest ${digests} )
  install_lua_module ( ${digest} lmd5.c LINK ${OPENSSL_CRYPTO_LIBRARY} )
  string ( TOUPPER ${digest} DIGEST )
  set_target_properties ( ${digest} PROPERTIES COMPILE_DEFINITIONS USE_${DIGEST}_OPENSSL )
endforeach ()

install_data ( README )
install_test ( test.lua )

# tests
file ( WRITE "${CMAKE_CURRENT_BINARY_DIR}/t/t.lua" "
for name in ('${digests}'):gmatch'[^;]+' do require(name) end
dofile '${CMAKE_CURRENT_SOURCE_DIR}/test.lua'
")
add_lua_test ( "${CMAKE_CURRENT_BINARY_DIR}/t/t.lua"
               WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" )
