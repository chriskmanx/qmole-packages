@echo off

rem ##########################################################################
rem # Scala Bazaars command-line client 1.24tmp
rem ##########################################################################
rem # (c) 2002-2007 LAMP/EPFL
rem #
rem # This is free software; see the distribution for copying conditions.
rem # There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
rem # PARTICULAR PURPOSE.
rem ##########################################################################

rem We adopt the following conventions:
rem - System/user environment variables start with a letter
rem - Local batch variables start with an underscore ('_')

if "%OS%"=="Windows_NT" (
  @setlocal
  call :set_home
  set _ARGS=%*
) else (
  set _SCALA_HOME=%SCALA_HOME%
  rem The following line tests SCALA_HOME instead of _SCALA_HOME, because
  rem the above change to _SCALA_HOME is not visible within this block.
  if "%SCALA_HOME%"=="" goto error1
  call :set_args
)

rem We use the value of the JAVACMD environment variable if defined
set _JAVACMD=%JAVACMD%
if "%_JAVACMD%"=="" set _JAVACMD=java

rem We use the value of the JAVA_OPTS environment variable if defined
set _JAVA_OPTS=%JAVA_OPTS%
if "%_JAVA_OPTS%"=="" set _JAVA_OPTS=-Xmx256M -Xms16M

set _EXTENSION_CLASSPATH=
if "%_EXTENSION_CLASSPATH%"=="" (
  for %%f in ("%_SCALA_HOME%\lib\*") do call :add_cpath "%%f"
  if "%OS%"=="Windows_NT" (
    for /d %%f in ("%_SCALA_HOME%\lib\*") do call :add_cpath "%%f"
  )
)

set _BOOT_CLASSPATH=%_SCALA_HOME%\lib\sbaz.jar;%_SCALA_HOME%\misc\sbaz\scala-library.jar
if "%_BOOT_CLASSPATH%"=="" (
  if exist "%_SCALA_HOME%\lib\scala-library.jar" (
    set _BOOT_CLASSPATH=%_SCALA_HOME%\lib\scala-library.jar
  )
  if exist "%_SCALA_HOME%\lib\library" (
    set _BOOT_CLASSPATH=%_SCALA_HOME%\lib\library
  )
)

set _PROPS=-Dscala.home="%_SCALA_HOME%" -Denv.classpath="%CLASSPATH%" -Denv.emacs="%EMACS%" 

rem echo %_JAVACMD% -Xbootclasspath/a:"%_BOOT_CLASSPATH%" %_JAVA_OPTS% %_PROPS% -cp "%_EXTENSION_CLASSPATH%" sbaz.clui.CommandLine  %_ARGS%
%_JAVACMD% -Xbootclasspath/a:"%_BOOT_CLASSPATH%" %_JAVA_OPTS% %_PROPS% -cp "%_EXTENSION_CLASSPATH%" sbaz.clui.CommandLine  %_ARGS%
goto end

rem ##########################################################################
rem # subroutines

:update_sbaz
  set _SUFFIX=.tmp
  set _SBAZ_JAR="%_SCALA_HOME%"\lib\sbaz.jar
  if exist "%_SBAZ_JAR%%_SUFFIX%" move /y %_SBAZ_JAR%%_SUFFIX% %_SBAZ_JAR%
  set _SCALA_LIB_JAR="%_SCALA_HOME%"\misc\sbaz\scala-library.jar
  if exist "%_SCALA_LIB_JAR%%_SUFFIX%" move /y %_SCALA_LIB_JAR%%_SUFFIX% %_SCALA_LIB_JAR%
goto :eof

:add_cpath
  if "%_EXTENSION_CLASSPATH%"=="" (
    set _EXTENSION_CLASSPATH=%~1
  ) else (
    set _EXTENSION_CLASSPATH=%_EXTENSION_CLASSPATH%;%~1
  )
goto :eof

rem Variable "%~dps0" works on WinXP SP2 or newer
rem (see http://support.microsoft.com/?kbid=833431)
rem set _SCALA_HOME=%~dps0..
:set_home
  set _BIN_DIR=
  for %%i in (%~sf0) do set _BIN_DIR=%_BIN_DIR%%%~dpsi
  set _SCALA_HOME=%_BIN_DIR%..
goto :eof

:set_args
  set _ARGS=
  :loop
  rem Argument %1 may contain quotes so we use parentheses here
  if (%1)==() goto :eof
  set _ARGS=%_ARGS% %1
  shift
  goto loop

rem ##########################################################################
rem # errors

:error1
echo ERROR: environment variable SCALA_HOME is undefined. It should point to your installation directory.
goto end

:end
call :update_sbaz
if "%OS%"=="Windows_NT" @endlocal
