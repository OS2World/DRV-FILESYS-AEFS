# Changes from the upstream AEFS (commit e7a9bf8, version "0.4pre262")

Upstream state is tagged `upstream-original`; the changes are separate commits.

## Step 1 - build with the new tools (no logic change)
* `compile_gcc.cmd` (new): builds the daemon and the utilities (`aefsdmn`, `mkaefs`, `aefsck`, `aefsdump`, `aefsutil`, `aefsparm`,
  `mntaefs`, `umntaefs`) with GCC 9 / kLIBC (`-Zomf -Zmt`, linked by wlink). The file list is written out file by file because the
  OS/2 `CMD.EXE` has no `CALL :label`. The daemon's `ea.c` is compiled as `d_ea.obj` (name clash with `corefs\ea.c`).
  No `-lbsd`/`-Zcrtdll` (EMX only); `-lsyslog` for the syslog calls.
* `src\config.h` (new, replaces the autoconf-generated file): `HAVE_SNPRINTF`, `HAVE_STRCASECMP`, `HAVE_STRICMP`,
  `HAVE_STRING_H`, `SIZEOF_INT/LONG` = 4, little endian, `AEFS_VERSION`, `OPEN_FILES_LIMIT` (they were `-D` options of the old
  makefiles). The source of the daemon and the programs is otherwise unchanged and compiles without errors.
* Layout: sources moved to `src\`, the old makefiles/autoconf files to `doc\original\`, `COPYING` renamed `LICENSE`.
* Not built: `nfsd` (NFS server, needs rpcgen), `fuse`, `test\write.c`.
* Baseline test (Dev VM): `mkaefs`, `aefsck`, `aefsutil` create, check and list an encrypted volume.

## Step 2 - the stub driver on ArcaOS
* `Makefile.wat`, `compile_wat.cmd` (new): Open Watcom 2 build of the ring 0 stub (16-bit, `wcc -ml`, `wlink system os2 dll`,
  FSHELPER imports by ordinal, exports of the data `FS_NAME`/`FS_ATTRIBUTE`; the `FS_xxx` functions use `_export`). The
  original needed Microsoft C 6.00 and IBM libraries.
* Output renamed `stubfsd.ifs` -> `aefs.ifs`, module name AEFS, default file system name `AEFS`: ArcaOS already loads a
  `STUBFSD.IFS` (ISOFS) and two modules with the same name must not be loaded.
* Headers: the IBM-derived `fsd.h` (and the IBM `dhcalls.h`, `fsh.h`, not in the repository) replaced by the clean-room
  `fsd.h`, `fsh.h`, `devhelp.h`, `dhwrap.asm` (see `PROVENANCE.md`); `ring0types.h` supplies `APIRET`, `LONGLONG` and
  `FIL_QUERYEASFROMLIST` for the 16-bit headers. `fsd.h` has `#define far` for GCC, so the daemon uses the same definitions.
* `stubfsd.c`: `#include "devhelp.h"` instead of `dhcalls.h`; the file system name given on the IFS line was copied without a
  bound check (11-byte buffer, terminator written past it): now at most 10 characters.

## Step 3 - boot messages (new feature)
* `bootmsg.c/h`, `version.h` (new): switches `/V /Q /W /AA` after the file system name, messages prefixed `AEFS: `, quiet by
  default, failure text `AEFS: AEFS.IFS could not be loaded. <reason>`. A first word starting with `/` is a switch, the
  name stays `AEFS`.
* Version 0.4a1 (`AEFS_VERSION` in `src\config.h`, `version.h`).

## Documentation
* `README.md`, `doc\PROVENANCE.md`, `doc\CHANGES.md` (new); `src\readme.src` (requirements, installation, building updated);
  `doc\readme.txt` and `doc\readme.html` generated from it with the upstream `emxdoc` built with GCC.

## Tests (Playground VM, ArcaOS 5.1.2, 2026-11-23; `test\aefstest1.cmd`)
* The stub loads without messages; with `/v /w /aa` the version banner, key wait and beep.
* Daemon started, volume created (Rijndael-128), mounted as X:; `dir`, copy of a 1.27 MB DLL and a text file, `md` and rename
  in a subdirectory: MD5 sums of the copies on X: equal the originals; delete and `rmdir`; `umntaefs`; `aefsck`: no errors;
  `aefsutil ls` lists the files from the encrypted storage. Run twice with the same result (the second run with the
  boot-message build).
* Not tested: Twofish, real hardware, large volumes, extended attributes, `FS_FINDNOTIFY`, shutdown with a mounted volume.
