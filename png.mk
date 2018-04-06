PNG_URL := https://sourceforge.net/projects/libpng/files/libpng16/1.6.34/libpng-1.6.34.tar.xz
PNG_TAR := $(call download,$(PNG_URL))
PNG_EXTRACT := $(call extract,$(PNG_TAR))
PNG := $(INSTALL)/lib/libpng.a

$(PNG_EXTRACT)/Makefile: $(PNG_EXTRACT).extracted $(host-toolchain)
	cd $(dir $@) \
	&& ./configure \
		--prefix=$(INSTALL) \
		--host=$(HOST) \
		--build=$(BUILD) \
		CPPFLAGS="$(CROSS_CPPFLAGS)" \
		CFLAGS="$(CROSS_CFLAGS)" \
		LDFLAGS="$(CROSS_LDFLAGS)" \
		PKG_CONFIG_LIBDIR="$(CROSS_PKG_CONFIG_LIBDIR)" \
		CC=$(CROSS_CC)

$(PNG): $(PNG_EXTRACT)/Makefile
	$(MAKE) -C $(PNG_EXTRACT)
	$(MAKE) -C $(PNG_EXTRACT) install

$(compile-host-1): $(PNG)
