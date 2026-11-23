# AEFS - Alternate Extended File System (cryptographic file system for OS/2 and ArcaOS)

AEFS stores encrypted files inside an ordinary directory of any file system and shows them as a normal drive letter on
OS/2 and ArcaOS. Rijndael (AES) and Twofish are supported, extended attributes are supported.

| | |
|---|---|
| Status | working in a virtual machine (mount, read, write, rename, delete, check); alpha |
| Version | 0.4a1 (based on the upstream development version "0.4pre262", last upstream change 2015-05-06) |
| Tested on | ArcaOS 5.1.2 VirtualBox virtual machine, small test volume. Not tested on real hardware. |
| License | GNU General Public License, version 2 or later (`LICENSE`). The kernel interface headers in `src\ifsdriver` are LGPL 2.1 or later. |
| Authors | Eelco Dolstra (AEFS, 1999-2015); this update: OS2World |
| Original source | https://github.com/OS2World/DRV-FILESYS-AEFS (tag `upstream-original`, commit e7a9bf8) |
| Build tools | Open Watcom 2 (stub driver), GCC 9 for OS/2 with kLIBC (daemon and programs) |

## How it works

* `aefs.ifs`, a small ring 0 file system driver ("stub"), receives the file system requests from OS/2 and hands them to
* `aefsdmn.exe`, a ring 3 daemon, which does the real work (decryption, directories, caching).
* `mkaefs`, `mntaefs`, `umntaefs`, `aefsck`, `aefsdump`, `aefsutil`, `aefsparm` create, mount, unmount, check and inspect volumes.

The manual is `doc\readme.txt` (or `readme.html`); it is the original manual with the installation and build chapters updated.

## Install

1. Back up `CONFIG.SYS` and know how to edit it at boot (Alt+F1). A bad driver can stop the boot.
2. Copy the files of `bin\` to a directory, for example `C:\AEFS`. The programs need the kLIBC runtime (part of ArcaOS).
3. Add to `CONFIG.SYS`:

```
IFS=C:\AEFS\AEFS.IFS AEFS
RUN=C:\AEFS\AEFSDMN.EXE
```

4. Reboot. Then, for example:

```
mkaefs -k secret C:\crypto        (creates the volume directory C:\crypto, must not exist)
mntaefs -k secret X: C:\crypto    (mounts it as drive X:)
umntaefs X:
```

(`-k` puts the passphrase on the command line; without it the programs ask for it.)

## Parameters of the IFS line

The driver is quiet at boot (only errors), following the EDM2 "Suggestion for OS/2 and eComStation Drivers Arguments".
The first word is the file system name (default `AEFS`); then:

| Parameter | Effect |
|---|---|
| `/V` | print the version |
| `/Q` | no messages at all |
| `/W` | wait for a key after the messages |
| `/AA` | beep when the driver loaded |

Messages start with `AEFS: `; a failure reads `AEFS: AEFS.IFS could not be loaded. <reason>`.
The options of the daemon and the programs are described in the manual.

## Build

From the project root on ArcaOS (Open Watcom 2 in `C:\WATCOM`, GCC 9 and `watcom-wlink-hll` from ANPM):

```
compile_wat.cmd       the stub driver  -> bin\aefs.ifs   (log: compile_wat.log)
compile_gcc.cmd       the daemon and programs -> bin\*.exe (log: compile.log)
```

`compile_wat.cmd clean` and `compile_gcc.cmd clean` remove the results. The original autoconf/make build files are kept in
`doc\original` for reference; they are not used. The stub is a 16-bit module: Open Watcom `wcc -ml`, `wlink system os2 dll`
with the FSHELPER entry points imported by ordinal (see `Makefile.wat`).

## Test

`test\aefstest1.cmd` starts the daemon, creates and mounts an encrypted volume, copies files (a 1.2 MB DLL and small files),
compares MD5 sums, renames, deletes, unmounts, and runs `aefsck` and `aefsutil`. See `doc\CHANGES.md` for the results.

## Known issues

* Alpha: tested only in a VM, with a small volume and the default cipher (Rijndael). Not tested: Twofish, real hardware,
  large volumes, extended attributes, many files, shutdown with a mounted volume (unmount first).
* The NFS server and the FUSE server of the original package are not built (they are for other operating systems).
* The daemon must be running before a volume is mounted (`RUN=` in `CONFIG.SYS`).
* `aefsck` reports "isf: longer than necessary ... not an error" on a new volume (upstream behaviour).
* The ring 0 stub uses a clean-room set of kernel interface headers (see `doc\PROVENANCE.md`).

## Changelog

* 0.4a1 - first update for ArcaOS: new build with Open Watcom 2 and GCC 9; clean-room kernel headers; EDM2 boot parameters
  `/V /Q /W /AA`; the IFS file is now `AEFS.IFS` (it was `STUBFSD.IFS`, which clashes with the ArcaOS ISOFS stub).
