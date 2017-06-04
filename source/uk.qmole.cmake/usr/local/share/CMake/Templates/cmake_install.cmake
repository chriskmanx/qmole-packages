# Install script for directory: /home/chris/cmake-2.3.4-20060317/Templates

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME Release)
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT CMAKE_INSTALL_CONFIG_NAME)

FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CPackConfig.cmake.in")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/TestDriver.cxx.in")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CMakeLists.txt")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CPack.GenericDescription.txt")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CPack.GenericLicense.txt")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CPack.GenericWelcome.txt")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/DartTestfile.txt")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CMakeVisualStudio6Configurations.cmake")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/CMakeWindowsSystemConfig.cmake")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/cmake_install.cmake")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/DLLFooter.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/DLLHeader.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/EXEFooter.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/EXEHeader.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/EXEWinHeader.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/UtilityFooter.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/UtilityHeader.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/staticLibFooter.dsptemplate")
FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/CMake/Templates" TYPE FILE FILES "/home/chris/cmake-2.3.4-20060317/Templates/staticLibHeader.dsptemplate")
