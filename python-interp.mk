#####################
# build-python
PYTHON_URL := https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz
PYTHON_TAR := $(call download,$(PYTHON_URL))
BUILD_PYTHON_EXTRACT := $(call extract,$(PYTHON_TAR))
BUILD_PYTHON_BUILDDIR := $(WORKING)/build-python/build
BUILD_PYTHON_INSTALL := $(WORKING)/build-python/install
BUILD_PYTHON := $(BUILD_PYTHON_INSTALL)/bin/python3

$(BUILD_PYTHON_BUILDDIR)/Makefile: $(BUILD_PYTHON_EXTRACT).extracted \
		| $(BUILD_PYTHON_BUILDDIR)
	cd $(dir $@) && $(BUILD_PYTHON_EXTRACT)/configure \
		--prefix=$(BUILD_PYTHON_INSTALL) \
		--disable-shared

$(BUILD_PYTHON): $(BUILD_PYTHON_BUILDDIR)/Makefile
	$(MAKE) -C $(BUILD_PYTHON_BUILDDIR)
	$(MAKE) -C $(BUILD_PYTHON_BUILDDIR) install

$(build-python-interp): $(BUILD_PYTHON)

##################################
# host-python
HOST_PYTHON_EXTRACT := $(call extract-to,$(WORKING)/host-python,$(PYTHON_TAR))
HOST_PYTHON_BUILDDIR := $(WORKING)/host-python/build
HOST_PYTHON := $(INSTALL)/bin/python3

$(HOST_PYTHON_EXTRACT).patched: $(HOST_PYTHON_EXTRACT).extracted
	sed -i 's!/bin/sh!/system/bin/sh!' $(HOST_PYTHON_EXTRACT)/Lib/subprocess.py
	touch $@

$(HOST_PYTHON_BUILDDIR)/config.site: | $(HOST_PYTHON_BUILDDIR)
	echo 'ac_cv_file__dev_ptmx=no' > $@
	echo 'ac_cv_file__dev_ptc=no' >> $@
	echo 'ac_cv_header_langinfo_h=no' >> $@

$(HOST_PYTHON_BUILDDIR)/Makefile: $(HOST_PYTHON_EXTRACT).patched \
		$(HOST_PYTHON_BUILDDIR)/config.site $(BUILD_PYTHON) $(host-toolchain) \
		$(compile-host) | $(HOST_PYTHON_BUILDDIR)
	cd $(dir $@) \
	&& echo 'ac_cv_file__dev_ptmx=no' > config.site \
	&& echo 'ac_cv_file__dev_ptc=no' >> config.site \
	&& echo 'ac_cv_header_langinfo_h=no' >> config.site \
	&& $(HOST_PYTHON_EXTRACT)/configure \
			--prefix=$(INSTALL) \
			--disable-shared \
			--host=$(HOST) \
			--build=$(BUILD) \
			--disable-ipv6 \
			--without-ensurepip \
			--with-system-ffi \
			CONFIG_SITE=$(HOST_PYTHON_BUILDDIR)/config.site \
			CC=$(CROSS_CC) \
			CXX=$(CROSS_CXX) \
			LN='ln -s' \
			PKG_CONFIG_LIBDIR=$(CROSS_PKG_CONFIG_LIBDIR) \
			LDFLAGS="$(CROSS_LDFLAGS) -L$(INSTALL)/lib -L$(CROSS_SYSROOT)/usr/lib" \
			CFLAGS="$(CROSS_CFLAGS)" \
			CPPFLAGS="$(CROSS_CPPFLAGS) -I$(INSTALL)/include -I$(CROSS_SYSROOT)/usr/include"

$(HOST_PYTHON): export PATH = $(dir $(BUILD_PYTHON)):$(COMPILE_HOST_PATH)
$(HOST_PYTHON): $(HOST_PYTHON_BUILDDIR)/Makefile
	$(MAKE) -C $(HOST_PYTHON_BUILDDIR)
	$(MAKE) -C $(HOST_PYTHON_BUILDDIR) install

$(host-python-interp): $(HOST_PYTHON)

$(BUILD_PYTHON_BUILDDIR) $(HOST_PYTHON_BUILDDIR):
	mkdir -p $@

