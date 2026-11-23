@echo off
rem AEFS test 1 (run on the test machine as the user who may start daemons): start the daemon, make and mount an encrypted volume, copy files, compare, unmount, check. The paths are those of the Playground VM: binaries are copied from the D: share to C:AEFS first; for another machine copy bin*.exe to C:AEFS yourself and delete the "copy D:" line. The volume C:AEFSDATA1 must not exist.
set OUT=C:\AEFS\test1.log
set BIN=C:\AEFS
set PATH=C:\usr\bin;%PATH%
set UNIXROOT=C:
set DPATH=C:\OS2\SYSTEM;C:\OS2;C:\OS2\MDOS;%DPATH%
copy D:\Projects\Drivers\DRV-FILESYS-AEFS\bin\*.exe C:\AEFS > nul
echo ==== start daemon > %OUT%
detach %BIN%\aefsdmn.exe
echo ==== mkaefs >> %OUT%
%BIN%\mkaefs.exe -k testpw C:\AEFSDATA1 >> %OUT% 2>&1
echo ==== mntaefs >> %OUT%
%BIN%\mntaefs.exe -k testpw X: C:\AEFSDATA1 >> %OUT% 2>&1
echo ==== dir X: >> %OUT%
dir X: >> %OUT% 2>&1
echo ==== copy files >> %OUT%
copy C:\CONFIG.SYS X:\config.sys >> %OUT% 2>&1
copy C:\OS2\DLL\PMMERGE.DLL "X:\A long name with spaces.dll" >> %OUT% 2>&1
md X:\sub >> %OUT% 2>&1
copy C:\CONFIG.SYS X:\sub\inner.txt >> %OUT% 2>&1
ren X:\sub\inner.txt renamed.txt >> %OUT% 2>&1
echo ==== dir X: after >> %OUT%
dir X: /s >> %OUT% 2>&1
echo ==== md5 >> %OUT%
C:\usr\bin\md5sum.exe C:/CONFIG.SYS X:/config.sys X:/sub/renamed.txt C:/OS2/DLL/PMMERGE.DLL "X:/A long name with spaces.dll" >> %OUT% 2>&1
echo ==== delete >> %OUT%
del X:\sub\renamed.txt >> %OUT% 2>&1
rmdir X:\sub >> %OUT% 2>&1
dir X: >> %OUT% 2>&1
echo ==== umntaefs >> %OUT%
%BIN%\umntaefs.exe X: >> %OUT% 2>&1
echo ==== aefsck >> %OUT%
%BIN%\aefsck.exe -k testpw C:\AEFSDATA1 >> %OUT% 2>&1
echo ==== aefsutil ls >> %OUT%
%BIN%\aefsutil.exe -k testpw -l C:\AEFSDATA1 ls / >> %OUT% 2>&1
echo ==== end >> %OUT%
