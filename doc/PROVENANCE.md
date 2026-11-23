# Provenance of the kernel interface headers

The ring 0 stub of AEFS needs declarations of the OS/2 file system driver interface (the records the kernel passes to the
`FS_xxx` entry points), of the FSHELPER services and of a few DevHelp services.

* The original package used `ifsdriver\fsd.h`, a file that carries the IBM revision line of the IBM `fsd.h`, and included
  `dhcalls.h` and `fsh.h` from the IBM Device Driver Kit, which were not part of the repository. These are not used any more.
* `src\ifsdriver\fsd.h`, `fsh.h`, `devhelp.h` and `dhwrap.asm` are clean-room files written by OS2World from public
  documentation (the IBM IFS and device driver reference books), first for the HFS/2 and FS-EXFAT drivers, which load and run
  on ArcaOS. They are released under the LGPL 2.1 or later so that they can be used in GPL projects.
* `src\ifsdriver\ring0types.h` and `bootmsg.c/h` were written for this project.
* The original `fsd.h` is still in the git history (tag `upstream-original`) but is not used.
