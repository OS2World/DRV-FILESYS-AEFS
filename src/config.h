/* config.h - fixed configuration for the OS/2 (kLIBC, GCC) build.
   Replaces the config.h that the upstream autoconf script generated
   (the build no longer needs autoconf). */
#define HAVE_SNPRINTF 1
#define HAVE_STRCASECMP 1
#define HAVE_STRICMP 1
#define HAVE_STRING_H 1
#define SIZEOF_INT 4
#define SIZEOF_LONG 4
/* little endian: WORDS_BIGENDIAN is not defined */

/* Version string (the upstream makefile built it from the git revision count). */
#define AEFS_VERSION "AEFS 0.4pre262"

/* Maximum number of open files of the daemon. */
#define OPEN_FILES_LIMIT 512
