#LIBFFI_URL := https://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
LIBFFI_URL := https://github.com/atgreen/libffi/archive/59d44242e15d2979291fe6793ddfb2681b7480ef.zip
LIBFFI_TAR := $(call download,$(LIBFFI_URL))
#LIBFFI_EXTRACT := $(call extract,$(LIBFFI_TAR))
LIBFFI_EXTRACT := $(call extract,$(LIBFFI_TAR),libffi-59d44242e15d2979291fe6793ddfb2681b7480ef)
LIBFFI := $(INSTALL)/lib/libffi.a

$(LIBFFI_EXTRACT)/configure: $(LIBFFI_EXTRACT).extracted
	cd $(dir $@) && autoreconf --install

$(LIBFFI_EXTRACT)/Makefile: $(LIBFFI_EXTRACT)/configure $(host-toolchain)
	cd $(dir $@) \
	&& ./configure \
		--prefix=$(INSTALL) \
		--host=$(HOST) \
		--build=$(BUILD)

$(LIBFFI): export CC = $(CROSS_CC)
$(LIBFFI): export PKG_CONFIG_LIBDIR = $(CROSS_PKG_CONFIG_LIBDIR)
$(LIBFFI): $(LIBFFI_EXTRACT)/Makefile
	$(MAKE) -C $(LIBFFI_EXTRACT)
	$(MAKE) -C $(LIBFFI_EXTRACT) install

$(compile-host-1): $(LIBFFI)
