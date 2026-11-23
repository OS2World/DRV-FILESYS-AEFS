/*
 * bootmsg.h - boot messages and parameters of the AEFS stub IFS.
 * Copyright (c) 2026 OS2World. GNU General Public License, version 2 or later, see LICENSE.
 */
#ifndef AEFS_BOOTMSG_H_INCLUDED
#define AEFS_BOOTMSG_H_INCLUDED

/* Handle the switches of the IFS= line (/V /Q /W /AA) and print the verbose banner.
   Returns 0, or an OS/2 error code if the driver must not load. */
int BootInit(char far *pcParm);

/* Print "AEFS: AEFS.IFS could not be loaded. <reason>" (unless /Q). */
void BootFail(char far *pszReason);

/* Last step of FS_INIT: wait for a key (/W), beep (/AA). Returns rc. */
int BootDone(int rc);

#endif
