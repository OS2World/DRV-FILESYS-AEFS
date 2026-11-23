@echo off
rem compile_gcc.cmd - build the AEFS daemon and the utilities (32-bit, GCC 9 / kLIBC)
rem   compile_gcc.cmd         build, log in compile.log, output in bin\
rem   compile_gcc.cmd clean   remove bin\ and the log
rem Needs GCC 9 (ANPM) and watcom-wlink-hll (wl.exe) with Open Watcom at C:\WATCOM.
rem The file list is written out file by file because the OS/2 CMD.EXE has no CALL :label.
set WATCOM=C:\WATCOM
set PATH=C:\usr\bin;%WATCOM%\BINP;%WATCOM%\BINW;%PATH%
set EMXOMFLD_TYPE=WLINK
set EMXOMFLD_LINKER=wl.exe
set EMXOMFLD_PRELINK=0
set UNIXROOT=C:
set C_INCLUDE_PATH=C:/usr/include;C:/os2tk45/h
set LIBRARY_PATH=C:/usr/lib
if "%1"=="clean" goto clean
set INCS=-Isrc/corefs -Isrc/ciphers -Isrc/misc -Isrc/ifsdriver -Isrc/system -Isrc/system/os2 -Isrc/utils -Isrc/ifsdaemon -Isrc
set DEFS=-DSYSTEM_os2 -DHAVE_CONFIG_H
set CF=-Zomf -Zmt -O2 -Wall -Wno-parentheses %INCS% %DEFS%
if not exist bin md bin
if exist bin\*.exe del bin\*.exe < nul
if exist bin\obj del bin\obj\*.obj < nul
if not exist bin\obj md bin\obj
echo ==== compile > compile.log
gcc %CF% -c -o bin\obj\getopt.obj src/misc/getopt.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\getopt1.obj src/misc/getopt1.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\missing.obj src/misc/missing.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\logging.obj src/misc/logging.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\os2.obj src/system/os2/os2.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\cipher.obj src/ciphers/cipher.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\ciphertable.obj src/ciphers/ciphertable.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\identity.obj src/ciphers/identity.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\rijndael.obj src/ciphers/rijndael.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\sha.obj src/ciphers/sha.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\twofish.obj src/ciphers/twofish.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\basefile.obj src/corefs/basefile.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\comparators.obj src/corefs/comparators.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\coreutils.obj src/corefs/coreutils.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\directory.obj src/corefs/directory.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\ea.obj src/corefs/ea.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\infosector.obj src/corefs/infosector.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\sector.obj src/corefs/sector.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\storage.obj src/corefs/storage.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\superblock.obj src/corefs/superblock.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\symlink.obj src/corefs/symlink.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\utilutils.obj src/utils/utilutils.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\aefsdmn.obj src/ifsdaemon/aefsdmn.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\attach.obj src/ifsdaemon/attach.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\find.obj src/ifsdaemon/find.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\misc.obj src/ifsdaemon/misc.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\dir.obj src/ifsdaemon/dir.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\openclose.obj src/ifsdaemon/openclose.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\fileio.obj src/ifsdaemon/fileio.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\fileinfo.obj src/ifsdaemon/fileinfo.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\fileop.obj src/ifsdaemon/fileop.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\d_ea.obj src/ifsdaemon/ea.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\utils.obj src/ifsdaemon/utils.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\mkaefs.obj src/utils/mkaefs.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\aefsck.obj src/utils/aefsck.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\aefsdump.obj src/utils/aefsdump.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\aefsutil.obj src/utils/aefsutil.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\aefsparm.obj src/ifsutils/aefsparm.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\mntaefs.obj src/ifsutils/mntaefs.c >> compile.log 2>&1
gcc %CF% -c -o bin\obj\umntaefs.obj src/ifsutils/umntaefs.c >> compile.log 2>&1
echo ==== link >> compile.log
set LIBS=bin\obj\getopt.obj bin\obj\getopt1.obj bin\obj\missing.obj bin\obj\logging.obj bin\obj\os2.obj bin\obj\cipher.obj bin\obj\ciphertable.obj bin\obj\identity.obj bin\obj\rijndael.obj bin\obj\sha.obj bin\obj\twofish.obj bin\obj\basefile.obj bin\obj\comparators.obj bin\obj\coreutils.obj bin\obj\directory.obj bin\obj\ea.obj bin\obj\infosector.obj bin\obj\sector.obj bin\obj\storage.obj bin\obj\superblock.obj bin\obj\symlink.obj
gcc -Zomf -Zmt -o bin\aefsdmn.exe bin\obj\aefsdmn.obj bin\obj\attach.obj bin\obj\find.obj bin\obj\misc.obj bin\obj\dir.obj bin\obj\openclose.obj bin\obj\fileio.obj bin\obj\fileinfo.obj bin\obj\fileop.obj bin\obj\d_ea.obj bin\obj\utils.obj %LIBS% -lsyslog >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\mkaefs.exe bin\obj\mkaefs.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\aefsck.exe bin\obj\aefsck.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\aefsdump.exe bin\obj\aefsdump.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\aefsutil.exe bin\obj\aefsutil.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\aefsparm.exe bin\obj\aefsparm.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\mntaefs.exe bin\obj\mntaefs.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
gcc -Zomf -Zmt -o bin\umntaefs.exe bin\obj\umntaefs.obj bin\obj\utilutils.obj %LIBS% >> compile.log 2>&1
set FAIL=0
if not exist bin\aefsdmn.exe set FAIL=1
if not exist bin\mkaefs.exe set FAIL=1
if not exist bin\aefsck.exe set FAIL=1
if not exist bin\aefsdump.exe set FAIL=1
if not exist bin\aefsutil.exe set FAIL=1
if not exist bin\aefsparm.exe set FAIL=1
if not exist bin\mntaefs.exe set FAIL=1
if not exist bin\umntaefs.exe set FAIL=1
if "%FAIL%"=="1" goto failed
echo OK: bin\aefsdmn.exe bin\mkaefs.exe bin\aefsck.exe bin\aefsdump.exe bin\aefsutil.exe bin\aefsparm.exe bin\mntaefs.exe bin\umntaefs.exe
echo OK >> compile.log
goto end
:failed
echo FAILED, see compile.log (some programs were not built)
echo FAILED >> compile.log
goto end
:clean
if exist bin rmdir /s /q bin
if exist compile.log del compile.log
:end
