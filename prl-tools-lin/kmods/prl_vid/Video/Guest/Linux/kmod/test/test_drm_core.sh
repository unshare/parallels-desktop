#!/bin/sh

KERNEL_DIR=$1
CC=$2

#	4.7 <= kernel
T0_0="#include <linux/version.h>
void test(void) {
	#if LINUX_VERSION_CODE < KERNEL_VERSION(4,7,0)
	#error DRM is not supported for this kernel version
	#endif	
}"

#	4.14 <= kernel
T1_0="#include <drm/drm_plane.h>
int test(void) {
	return drm_universal_plane_init(
		(struct drm_device *)NULL,				/* dev */
		(struct drm_plane *)NULL,				/* plane */
		(uint32_t)0,							/* possible_crtcs */
		(const struct drm_plane_funcs *)NULL,	/* funcs */
		(const uint32_t *)NULL,					/* formats */
		(unsigned int)0,						/* format_count */
		(const uint64_t *)NULL,					/* format_modifiers */
		(enum drm_plane_type)0,					/* type */
		(const char *)\"%d\", (int)0);			/* name */
}"

#	4.19 <= kernel
T2_0="#include <drm/drm_connector.h>
int test(void) {
	return drm_connector_attach_encoder(
		(struct drm_connector *)NULL, 			/* connector*/
		(struct drm_encoder *)NULL);			/* encoder */
}"

#	4.7 <= kernel
T3_0="#include <drm/drm_atomic_helper.h>
void test(void) {
	__drm_atomic_helper_crtc_destroy_state(
		(struct drm_crtc_state *)NULL);			/* state */
}"

#	4.11 <= kernel
T4_0="#include <drm/drm_modeset_helper.h>
void test(void) {
	drm_helper_mode_fill_fb_struct(
		(struct drm_device *)NULL,				/* dev */
		(struct drm_framebuffer *)NULL,			/* fb */
		(const struct drm_mode_fb_cmd2 *)NULL); /* mode_cmd */
}"

#	4.9 <= kernel < 4.11
T4_1="#include <drm/drm_modeset_helper.h>
void test(void) {
	drm_helper_mode_fill_fb_struct(
		(struct drm_framebuffer *)NULL,			/* fb */
		(const struct drm_mode_fb_cmd2 *)NULL); /* mode_cmd */
}"

#	5.9 <= kernel
T5_0="#include <drm/drm_gem.h>
void test(void) {
	drm_gem_object_put(
		(struct drm_gem_object *)NULL);			/* obj */
}"

#	4.12 <= kernel < 5.9
T5_1="#include <drm/drm_gem.h>
void test(void) {
	drm_gem_object_put_unlocked(
		(struct drm_gem_object *)NULL);			/* obj */
}"

#	4.8 <= kernel
T6_0="#include <drm/drm_auth.h>
bool test(void) {
	return drm_is_current_master(
		(struct drm_file *)NULL);				/* fpriv */
}"

#	4.9 <= kernel
T7_0="enum drm_minor_type test(void) {
	return DRM_MINOR_PRIMARY;
}"

#	4.12 <= kernel
T8_0="#include <drm/drm_crtc.h>
int test(struct drm_crtc_funcs *funcs) {
	return funcs->gamma_set(
		(struct drm_crtc *)NULL,			/* crtc */
		(u16 *)NULL,						/* r */
		(u16 *)NULL,						/* g */
		(u16 *)NULL,						/* b */
		(uint32_t)0,						/* size */
		(struct drm_modeset_acquire_ctx *)NULL); /* ctx */
}"

#	4.8 <= kernel < 4.12
T8_1="#include <drm/drm_crtc.h>
int test(struct drm_crtc_funcs *funcs) {
	return funcs->gamma_set(
		(struct drm_crtc *)NULL,			/* crtc */
		(u16 *)NULL,						/* r */
		(u16 *)NULL,						/* g */
		(u16 *)NULL,						/* b */
		(uint32_t)0);						/* size */
}"

#	kernel < 4.8
T8_2="#include <drm/drm_crtc.h>
void test(struct drm_crtc_funcs *funcs) {
	funcs->gamma_set(
		(struct drm_crtc *)NULL,			/* crtc */
		(u16 *)NULL,						/* r */
		(u16 *)NULL,						/* g */
		(u16 *)NULL,						/* b */
		(uint32_t)0,						/* start */
		(uint32_t)0);						/* size */
}"

#	kernel < 4.14
T9_0="int test(struct drm_driver *drv) {
	return drv->set_busid(
		(struct drm_device *)NULL,			/* dev */
		(struct drm_master *)NULL);			/* master */
}"

#	4.8 <= kernel
T10_0="void test(struct drm_driver *drv) {
	drv->master_drop(
		(struct drm_device *)NULL,			/* dev */
		( struct drm_file *)NULL);			/* file_priv */
}"

#	4.17 <= kernel
T11_0="#include <linux/mm.h>
vm_fault_t test(struct vm_operations_struct *op) {
	return op->fault((struct vm_fault *)NULL);
}"

#	4.11 <= kernel < 4.17
T11_1="#include <linux/mm.h>
int test(struct vm_operations_struct *op) {
	return op->fault((struct vm_fault *)NULL);
}"

#	4.10 <= kernel
T12_0="#include <linux/mm.h>
unsigned long test(struct vm_fault *vmf) {
	return vmf->address;
}"

#	4.11 <= kernel
T13_0="#include <linux/kref.h>
unsigned int test(void) {
	return kref_read((const struct kref *)NULL);/* kref */
}"

#	kernel < 4.20
T14_0="#include <drm/drm_atomic_helper.h>
void test(void) {
	drm_atomic_helper_best_encoder(
		(struct drm_connector *)NULL);			/* connector */
}"

#	kernel <= 4.20
T15_0="void test(void) {
	drm_dev_unref(
		(struct drm_device *)NULL);				/* dev */
}"

#	4.8 <= kernel
T16_0="void test(struct drm_framebuffer *fb) {
	fb->hot_x = fb->hot_y = 0;
}"

#	5.7 <= kernel
T17_0="#include <drm/drm_fb_helper.h>
void test(void) {
	drm_fb_helper_init(
		(struct drm_device *)NULL,				/* dev */
		(struct drm_fb_helper *)NULL);			/* helper */
}"

#	4.11 <= kernel < 5,7
T17_1="#include <drm/drm_fb_helper.h>
void test(void) {
	drm_fb_helper_init(
		(struct drm_device *)NULL,				/* dev */
		(struct drm_fb_helper *)NULL,			/* helper */
		(int)0);								/* max_conn */
}"

#	5.2 <= kernel
T18_0="#include <drm/drm_fb_helper.h>
void test(void) {
	drm_fb_helper_fill_info(
		(struct fb_info *)NULL,						/* info */
		(struct drm_fb_helper *)NULL,				/* helper */
		(struct drm_fb_helper_surface_size *)NULL);	/* sizes */
}"

#	4.11 <= kernel < 5.2
T18_1="u8 test(struct drm_framebuffer *fb) {
	return fb->format->depth;
}"

#	kernel <= 4.10
T19_0="int test(struct drm_driver *drv) {
	return drv->unload((struct drm_device *)NULL);
}"

#	4.12 <= kernel
T20_0="#include <drm/drm_atomic_helper.h>
void test(void) {
	drm_atomic_helper_shutdown(
		(struct drm_device *)NULL);			/* dev */
}"

#  4.8 <= kernel <= 5.0
T20_1="#include <drm/drm_atomic_helper.h>
int test(void) {
	return drm_crtc_force_disable_all(
		(struct drm_device *)NULL);			/* dev */
}"

#	kernel < 5.4
T22_0=" unsigned int test(unsigned int features) {
	features |= DRIVER_PRIME;
    return 0;
}"

#	kernel < 5.9
T23_0="#include <drm/drm_modes.h>
int test(struct drm_display_mode *mode) {
	return mode->vrefresh;
}"

#	kernel < 5.9
T24_0="int test(struct drm_driver *drv) {
	return drv->master_set(
		(struct drm_device *)NULL,
		(struct drm_file *)NULL,
		true);
}"

#	kernel < 5.7
T25_0="int test(void) {
	return drm_fb_helper_single_add_all_connectors(
		(struct drm_fb_helper *)NULL);
}"

#	5.11 <= kernel
T26_0="#include <drm/drm_modeset_helper_vtables.h>
int test(struct drm_crtc_helper_funcs *funcs) {
	return funcs->atomic_check(
		(struct drm_crtc *)NULL,
		(struct drm_atomic_state *)NULL);
}"

#	kernel < 5.11
T27_0="void test(struct drm_driver *drv) {
	return drv->gem_free_object_unlocked(
		(struct drm_gem_object *)NULL);
}"

#	5.13 <= kernel
T28_0="#include <drm/drm_modeset_helper_vtables.h>
int test(struct drm_plane_helper_funcs *funcs) {
	return funcs->atomic_check(
		(struct drm_plane *)NULL,
		(struct drm_atomic_state *)NULL);
}"

tfunc() {
	local i=0

	while
		eval elem="\$${1}_${i}"
		[ -n "${elem}" ]
	do
		# cretate source
		echo "#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(5,5,0)
#include <drm/drmP.h>
#else
#include <drm/drm_drv.h>
#include <drm/drm_device.h>
#include <drm/drm_file.h>
#endif
${elem}" > test.c

		# make and delete source
		make -C "$KERNEL_DIR" M="$(pwd)" SRCROOT="$(pwd)" CC="$CC" > /dev/null 2>&1
		rm -f test.c

		i=$((i+1))
		# check result
		if [ -f test.o ]; then
			rm -f test.o
			echo $i
			return
		fi
	done

	echo 0
}

# create makefile
echo "ccflags-y += -I${1}/include -Werror" > Makefile
echo "obj-m += ./test.o" >> Makefile

if [ "$(tfunc T0)" -eq "1" ]
then
	echo "-DPRL_DRM_ENABLED=1"
	echo "-DPRL_DRM_UNIVERSAL_PLANE_INIT_X=$(tfunc T1)"
	echo "-DPRL_DRM_CONNECTOR_ATTACH_ENCODER_X=$(tfunc T2)"
	echo "-DPRL_DRM_ATOMIC_HELPER_CRTC_DESTROY_STATE_X=$(tfunc T3)"
	echo "-DPRL_DRM_HELPER_MODE_FILL_FB_STRUCT_X=$(tfunc T4)"
	echo "-DPRL_DRM_GEM_OBJECT_PUT_UNLOCKED_X=$(tfunc T5)"
	echo "-DPRL_DRM_IS_CURRENT_MASTER_X=$(tfunc T6)"
	echo "-DPRL_DRM_MINOR_PRIMARY_X=$(tfunc T7)"
	echo "-DPRL_KMS_CRTC_GAMMA_SET_X=$(tfunc T8)"
	echo "-DPRL_DRM_SET_BUSID_X=$(tfunc T9)"
	echo "-DPRL_DRM_MASTER_DROP_X=$(tfunc T10)"
	echo "-DPRL_DRM_VM_OPERATIONS_FAULT_X=$(tfunc T11)"
	echo "-DPRL_DRM_VM_FAULT_ADDRESS_X=$(tfunc T12)"
	echo "-DPRL_DRM_KREF_READ_X=$(tfunc T13)"
	echo "-DPRL_DRM_ATOMIC_HELPER_BEST_ENCODER_X=$(tfunc T14)"
	echo "-DPRL_DRM_DEV_PUT_X=$(tfunc T15)"
	echo "-DPRL_DRM_FB_HOT_XY=$(tfunc T16)"
	echo "-DPRL_DRM_FB_HELPER_INIT_X=$(tfunc T17)"
	echo "-DPRL_DRM_FB_HELPER_FILL_INFO_X=$(tfunc T18)"
	echo "-DPRL_DRM_DRIVER_UNLOAD_X=$(tfunc T19)"
	echo "-DPRL_DRM_ATOMIC_HELPER_SHUTDOWN_X=$(tfunc T20)"
	echo "-DPRL_DRM_DRIVER_PRIME_DEFINED=$(tfunc T22)"
	echo "-DPRL_DRM_MODE_VREFRESH_X=$(tfunc T23)"
	echo "-DPRL_DRM_MASTER_SET=$(tfunc T24)"
	echo "-DPRL_DRM_FB_HELPER_SINGLE_ADD_ALL_CONNECTORS=$(tfunc T25)"
	echo "-DPRL_KMS_CRTC_ATOMIC_STATE_X=$(tfunc T26)"
	echo "-DPRL_DRM_GEM_DRM_DRIVER_CALLS=$(tfunc T27)"
	echo "-DPRL_DRM_PLANE_HELPER_CALLS_X=$(tfunc T28)"
else
	echo "-DPRL_DRM_ENABLED=0"
fi

# cleanup
find . ! -name "$(basename $0)" -type f -exec rm -f {} +
