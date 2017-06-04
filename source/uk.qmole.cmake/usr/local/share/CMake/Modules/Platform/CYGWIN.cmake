SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared -Wl,--export-all-symbols -Wl,--enable-auto-import")
SET(CMAKE_SHARED_MODULE_CREATE_C_FLAGS ${CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS})
SET(CMAKE_DL_LIBS "-lgdi32" )
SET(CMAKE_SHARED_LIBRARY_PREFIX "cyg")
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
SET(CMAKE_SHARED_MODULE_PREFIX "lib")
SET(CMAKE_SHARED_MODULE_SUFFIX ".dll")
SET(CMAKE_IMPORT_LIBRARY_PREFIX "lib")
SET(CMAKE_IMPORT_LIBRARY_SUFFIX ".dll.a")
# no pic for gcc on cygwin
SET(CMAKE_SHARED_LIBRARY_C_FLAGS "")
SET(CMAKE_SHARED_LIBRARY_CXX_FLAGS "")
SET(CMAKE_EXECUTABLE_SUFFIX ".exe")          # .exe

# Modules have a different default prefix that shared libs.
SET(CMAKE_MODULE_EXISTS 1)

SET(CMAKE_FIND_LIBRARY_PREFIXES "cyg" "lib")
SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a")

SET(CMAKE_C_CREATE_SHARED_MODULE
  "<CMAKE_C_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_MODULE_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_C_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")
SET(CMAKE_CXX_CREATE_SHARED_MODULE
  "<CMAKE_CXX_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_MODULE_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS> -o <TARGET> <OBJECTS> <LINK_LIBRARIES>")

SET(CMAKE_C_CREATE_SHARED_LIBRARY
  "<CMAKE_C_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_C_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS> -o <TARGET> -Wl,--out-implib,<TARGET_IMPLIB> <OBJECTS> <LINK_LIBRARIES>")
SET(CMAKE_CXX_CREATE_SHARED_LIBRARY
  "<CMAKE_CXX_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> -o <TARGET> -Wl,--out-implib,<TARGET_IMPLIB> <OBJECTS> <LINK_LIBRARIES>")
INCLUDE(Platform/UnixPaths)
