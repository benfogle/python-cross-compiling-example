JPEG_URL := http://www.ijg.org/files/jpegsrc.v9b.tar.gz
JPEG_TAR := $(call download,$(JPEG_URL))
JPEG_EXTRACT := $(call extract,$(JPEG_TAR),jpeg-9b)
JPEG_BUILDDIR := $(WORKING)/jpeg-builddir
JPEG_LIB := $(INSTALL)/lib/libjpeg.a

$(JPEG_BUILDDIR)/Makefile: $(JPEG_EXTRACT) $(host-toolchain) | $(JPEG_BUILDDIR)
	cd $(dir $@) && $(JPEG_EXTRACT)/configure \
		--host=$(HOST) \
		--prefix=$(INSTALL) \
		CC=$(CROSS_CC) \
		PKG_CONFIG_LIBDIR=$(CROSS_PKG_CONFIG_LIBDIR)

$(JPEG_LIB): $(JPEG_BUILDDIR)/Makefile
	$(MAKE) -C $(JPEG_BUILDDIR)
	$(MAKE) -C $(JPEG_BUILDDIR) install

$(JPEG_BUILDDIR):
	mkdir -p $@

$(compile-host-1): $(JPEG_LIB)
