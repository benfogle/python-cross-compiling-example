FREETYPE_URL := https://downloads.sourceforge.net/project/freetype/freetype2/2.9/freetype-2.9.tar.bz2
FREETYPE_TAR := $(call download,$(FREETYPE_URL))
FREETYPE_EXTRACT := $(call extract,$(FREETYPE_TAR))
FREETYPE := $(INSTALL)/lib/libfreetype.a

$(FREETYPE_EXTRACT)/config.mk: $(FREETYPE_EXTRACT).extracted $(host-toolchain) \
		$(compile-host-1)
	cd $(dir $@) \
	&& ./configure \
		--prefix=$(INSTALL) \
		--host=$(HOST) \
		--build=$(BUILD) \
		--with-png=no \
		CFLAGS="$(CROSS_CFLAGS)" \
		CPPFLAGS="$(CROSS_CPPFLAGS) -I$(INSTALL)/include" \
		LDFLAGS="$(CROSS_LDFLAGS)" \
		CC=$(CROSS_CC) \
		PKG_CONFIG_LIBDIR=$(CROSS_PKG_CONFIG_LIBDIR) \
		ZLIB_CFLAGS= \
		ZLIB_LIBS="-lz" \
		BZIP2_CFLAGS= \
		BZIP2_LIBS="-lbz2" \
		LIBPNG_CFLAGS= \
		LIBPNG_LIBS="-lpng"

$(FREETYPE): $(FREETYPE_EXTRACT)/config.mk
	PKG_CONFIG_LIBDIR=$(CROSS_PKG_CONFIG_LIBDIR) \
	$(MAKE) -C $(FREETYPE_EXTRACT) LIBPNG_LIBS=
	$(MAKE) -C $(FREETYPE_EXTRACT) install

$(compile-host-2): $(FREETYPE)
