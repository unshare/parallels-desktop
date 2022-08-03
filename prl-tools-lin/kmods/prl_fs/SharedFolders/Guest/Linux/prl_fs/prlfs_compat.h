/*
 * Copyright (c) 1999-2016 Parallels International GmbH.
 * All rights reserved.
 * http://www.parallels.com
 *
 * Parallels linux shared folders filesystem compatibility definitions.
 */

#ifndef __PRL_FS_COMPAT_H__
#define __PRL_FS_COMPAT_H__

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 6, 0)

#define PRLFS_PROC_OPS_INIT(_owner, _open, _read, _lseek, _release) \
	{ \
		.proc_open = _open, \
		.proc_read = _read, \
		.proc_lseek = _lseek, \
		.proc_release = _release, \
	}

#else

#define PRLFS_PROC_OPS_INIT(_owner, _open, _read, _lseek, _release) \
	{ \
		.owner = _owner, \
		.open = _open, \
		.read = _read, \
		.llseek = _lseek, \
		.release = _release, \
	}

#define proc_ops file_operations

#endif

#endif
