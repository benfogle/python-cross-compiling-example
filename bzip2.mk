BZIP2_URL := http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz
BZIP2_TAR := $(call download,$(BZIP2_URL))
BZIP2_EXTRACT := $(call extract,$(BZIP2_TAR))
BZIP2 := $(INSTALL)/lib/libbz2.a

$(BZIP2): export CC = $(CROSS_CC)
$(BZIP2): export PKG_CONFIG_LIBDIR = $(CROSS_PKG_CONFIG_LIBDIR)
$(BZIP2): $(BZIP2_EXTRACT).extracted $(host-toolchain)
	$(MAKE) -C $(BZIP2_EXTRACT) -f Makefile-libbz2_so \
		CC=$(CROSS_CC) \
		AR=$(CROSS_AR) \
		RANLIB=$(CROSS_RANLIB)
	$(MAKE) -C $(BZIP2_EXTRACT) \
		CC=$(CROSS_CC) \
		AR=$(CROSS_AR) \
		RANLIB=$(CROSS_RANLIB) \
		libbz2.a
	cp -fd $(BZIP2_EXTRACT)/libbz2.a $(INSTALL)/lib/
	cp -fd $(BZIP2_EXTRACT)/libbz2.so* $(INSTALL)/lib/
	cp -fd $(BZIP2_EXTRACT)/bzlib.h $(INSTALL)/include

$(compile-host-1): $(BZIP2)
