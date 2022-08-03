/*
 * Copyright (c) 1999-2016 Parallels International GmbH.
 * All rights reserved.
 * http://www.parallels.com
 */

#ifndef __PRL_FSFREEZE_COMPAT_H__
#define __PRL_FSFREEZE_COMPAT_H__

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 6, 0)

#define PRLFS_FREEZE_PROC_OPS_INIT(_owner, _open, _read, _write, _lseek, _release) \
	{ \
		.proc_open = _open, \
		.proc_read = _read, \
		.proc_write = _write, \
		.proc_lseek = _lseek, \
		.proc_release = _release, \
	}

#else

#define PRLFS_FREEZE_PROC_OPS_INIT(_owner, _open, _read, _write, _lseek, _release) \
	{ \
		.owner = _owner, \
		.open = _open, \
		.read = _read, \
		.write = _write, \
		.llseek = _lseek, \
		.release = _release, \
	}

#define proc_ops file_operations

#endif

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5, 11, 0)

#define prl_freeze_bdev(bdev) freeze_bdev(bdev)
#define prl_thaw_bdev(bdev, sb) thaw_bdev(bdev)

#else

int prl_freeze_bdev(struct block_device *bdev)
{
	struct super_block *ret;

	ret = freeze_bdev(bdev);
	if (!ret)
		return -ENODEV;
	if (IS_ERR(ret))
		return PTR_ERR(ret);

	return 0;
}

#define prl_thaw_bdev(bdev, sb) thaw_bdev((bdev), (sb))

#endif

#endif
