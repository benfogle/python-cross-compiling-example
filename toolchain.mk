NDK_URL := https://dl.google.com/android/repository/android-ndk-r16b-linux-x86_64.zip
NDK_ZIP := $(call download,$(NDK_URL))
NDK_EXTRACT := $(call extract,$(NDK_ZIP),android-ndk-r16b)
NDK_STANDALONE := $(WORKING)/ndk-standalone

#################################################################
# Common flags, etc. that can be used in the build
BUILD := x86_64-linux-gnu
HOST := arm-linux-androideabi
CROSS_PREFIX := $(HOST)-
TOOLCHAIN_BIN := $(NDK_STANDALONE)/bin
CROSS_CC := $(CROSS_PREFIX)clang
CROSS_CXX := $(CROSS_PREFIX)clang++
CROSS_LD := $(CROSS_PREFIX)ld
CROSS_AR := $(CROSS_PREFIX)ar
CROSS_AS := $(CROSS_PREFIX)as
CROSS_RANLIB := $(CROSS_PREFIX)ranlib
CROSS_STRIP := $(CROSS_PREFIX)strip
CROSS_PKG_CONFIG_LIBDIR := $(INSTALL)/lib/pkgconfig
CROSS_SYSROOT := $(NDK_STANDALONE)/sysroot
HOST_SYSROOT := $(CROSS_SYSROOT)

CROSS_CPPFLAGS :=
CROSS_CFLAGS :=
CROSS_CXXFLAGS := $(CROSS_CFLAGS)

$(TOOLCHAIN_BIN)/$(CROSS_CC): $(NDK_EXTRACT) $(make-dirs)
	$(NDK_EXTRACT)/build/tools/make_standalone_toolchain.py \
		--arch arm \
		--api 21 \
		--stl libc++ \
		--force \
		--install-dir $(NDK_STANDALONE)

$(INSTALL)/lib/libc++_shared.so: $(TOOLCHAIN_BIN)/$(CROSS_CC) $(make-dirs)
	cp -rfd $(NDK_STANDALONE)/$(HOST)/lib/*.so $(INSTALL)/lib

COMPILE_HOST_PATH := $(TOOLCHAIN_BIN):$(PATH)
$(host-toolchain): $(TOOLCHAIN_BIN)/$(CROSS_CC)
$(host-toolchain): $(INSTALL)/lib/libc++_shared.so
$(compile-host): export PATH := $(TOOLCHAIN_BIN):$(PATH)
$(compile-host-1): export PATH := $(TOOLCHAIN_BIN):$(PATH)
$(compile-host-2): export PATH := $(TOOLCHAIN_BIN):$(PATH)
