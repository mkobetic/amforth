# Override default ARM toolchain for linux target.
# On MacOS assume homebrew installed toolchain.
ifeq ($(shell uname -s),Darwin)
	# On MacOS the tooling doesn't have the -none- bit.
	CROSS ?= arm-linux-gnueabihf-
	TC_DIR ?= $(shell brew --prefix arm-linux-gnueabihf-binutils)
else
	CROSS ?= arm-none-linux-gnueabihf-
endif

AMFORTH ?= $(shell git rev-parse --show-toplevel)
include $(AMFORTH)/arm/dev/Makefile
MCU_LD ?= linux.ld

# if you want to run standard tests you need WANT_IGNORECASE flag set
AOPTS +=--defsym WANT_IGNORECASE=1

QEMU=qemu-system-arm
LANG=C

build/amforth: build/amforth.o
	$(LD) -L ../../../core -T linux.ld -z max-page-size=4096 $< -o $@ 

# To run amforth in emulated container you can use a container runtime that supports --platform linux/arm/v7
# For MacOS check out https://orbstack.dev/ (Free for personal use)
# See Dockerfile for the details of what goes into the container image, tweak to heart's desire.
image: build/amforth
	docker build --tag amforth:latest .

# Starts the amforth container with a terminal session.
# Once terminal to the container opens you can start amforth, the binary is on the PATH.
# The whole host amforth directory is mounted in the container at /amforth.
# Apparently cannot run gdb inside the container, because ptrace sys call is not supported in emulation.
drun: image
	docker run --interactive --tty --rm \
		--volume $(shell pwd)/../../..:/amforth \
		amforth:latest

# Run standard tests and output the results, requires WANT_IGNORECASE enabled above
# because the standard tests are in all caps and all amforth words are in lowercase.
# Currently segfaults, presumably because variables don't work yet which are central
# to the implementation of the testing framework (see the tester source)
test: image
	docker run --rm --volume $(shell pwd)/../../..:/amforth amforth:latest /bin/sh -c \
<<<<<<< HEAD
		'cd amforth/lib/forth2012/tester; cat tester-amforth.frt core.fr | amforth'
=======
		'cd amforth/_common/lib/forth2012/tester; cat tester-amforth.frt core.fr | amforth'
>>>>>>> 9fd674a (remove common/ add RAMALLOT)

# Starts amforth under QEMU
# WARNING(mk): This seems incomplete and does not work at least on MacOSX;
#   tried many things to get raspios emulation going, but no luck so far :/
# setup some terminal settings. Otherwise all input will be echo'ed
# MACHINE = raspi2b
# IMAGE = 2025-12-04-raspios-trixie-armhf-lite.img
# KERNEL = kernel8.img
# DTB = bcm2709-rpi-2-b.dtb
run: build/amforth
	qemu-img resize build/amforth 128k
	stty -icanon -echo
 	$(QEMU) -machine raspi2b -display none -serial mon:stdio  || true
# 	$(QEMU) -machine $(MACHINE) -kernel $(KERNEL) -dtb $(DTB) -sd $(IMAGE) -nographic \
# 		-append "rw earlyprintk loglevel=8 console=ttyAMA1,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rootdelay=1" \
# 		|| true
# 	$(QEMU) -cpu arm1176 -m 256 -M versatilepb
# 		-kernel qemu/kernel-qemu-5.10.63-bullseye \
# 		-dtb mcu/linux-arm/qemu/versatile-pb-bullseye-5.10.63.dtb \
#     	-drive "file=$(IMAGE),if=none,index=0,media=disk,format=raw,id=disk0" \
#     	-device 'virtio-blk-pci,drive=disk0,disable-modern=on,disable-legacy=off' \
# 	    -net 'user,hostfwd=tcp::5022-:22' -net nic \
# 	    -append 'root=/dev/vda2 panic=1' \
#     	-no-reboot \
#     	-nographic || true
	stty sane

# NOTES
#
# ## Raspberry Pi OS Lite
# To get necessary image, kernel, dtb files for Raspbery PI emulation:
# * download the 32-bit Raspberry Pi OS Lite from https://www.raspberrypi.com/software/operating-systems/
# * decompress it (xz), mount it, and in the boot partition find:
#   * dtb file corresponding to raspi you want, e.g. for raspi2b bcm2709-rpi-2-b.dtb
#	* the kernel file, e.g. kernel8.img
#
# * https://interrupt.memfault.com/blog/emulating-raspberry-pi-in-qemu
#
# ## Alpine Linux
# * https://wiki.alpinelinux.org/wiki/Install_Alpine_in_QEMU
# * https://github.com/keygenqt/skill-qemu-alpine
