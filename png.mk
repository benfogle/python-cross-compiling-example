PNG_URL := https://sourceforge.net/projects/libpng/files/libpng16/1.6.34/libpng-1.6.34.tar.xz
PNG_TAR := $(call download,$(PNG_URL))
PNG_EXTRACT := $(call extract,$(PNG_TAR))
PNG := $(INSTALL)/lib/libpng.a

$(PNG_EXTRACT)/Makefile: $(PNG_EXTRACT).extracted $(host-toolchain)
	cd $(dir $@) \
	&& ./configure \
		--prefix=$(INSTALL) \
		--host=$(HOST) \
		--build=$(BUILD)

$(PNG): export CC = $(CROSS_CC)
$(PNG): export PKG_CONFIG_LIBDIR = $(CROSS_PKG_CONFIG_LIBDIR)
$(PNG): $(PNG_EXTRACT)/Makefile
	$(MAKE) -C $(PNG_EXTRACT)
	$(MAKE) -C $(PNG_EXTRACT) install

$(compile-host-1): $(PNG)
