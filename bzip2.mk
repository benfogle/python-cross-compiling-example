BZIP2_VERSION := 1.0.6
BZIP2_URL := https://downloads.sourceforge.net/project/bzip2/bzip2-$(BZIP2_VERSION).tar.gz
BZIP2_TAR := $(call download,$(BZIP2_URL))
BZIP2_EXTRACT := $(call extract,$(BZIP2_TAR))
BZIP2 := $(INSTALL)/lib/libbz2.so

# Bzip2 make file is so simple we'll just do it ourselves, adding the
# flags that we need. Otherwise we'd need to patch the makefile a bit.

BZIP2_SRC := \
	$(BZIP2_EXTRACT)/blocksort.c \
	$(BZIP2_EXTRACT)/huffman.c    \
	$(BZIP2_EXTRACT)/crctable.c   \
	$(BZIP2_EXTRACT)/randtable.c  \
	$(BZIP2_EXTRACT)/compress.c   \
	$(BZIP2_EXTRACT)/decompress.c \
	$(BZIP2_EXTRACT)/bzlib.c

BZIP2_OBJS := $(BZIP2_SRC:.c=.o)

# Have to tell make how to 'build' the source files
$(BZIP2_SRC): $(BZIP2_EXTRACT).extracted $(host-toolchain)

$(BZIP2_EXTRACT)/%.o: $(BZIP2_EXTRACT)/%.c
	$(CROSS_CC) $(CROSS_CFLAGS) -O2 -D_FILE_OFFSET_BITS=64 $< -c -o $@

$(BZIP2): $(BZIP2_EXTRACT).extracted $(host-toolchain) $(BZIP2_OBJS)
	$(CROSS_CC) -shared -Wl,-soname,libbz2.so.1.0 \
		-o $(dir $@)/libbz2.so.$(BZIP2_VERSION) \
		$(BZIP2_OBJS) \
		$(CROSS_LDFLAGS)
	ln -fs libbz2.so.$(BZIP2_VERSION) $@
	ln -fs libbz2.so.$(BZIP2_VERSION) $(dir $@)/libbz2.so.1.0
	cp -fd $(BZIP2_EXTRACT)/bzlib.h $(INSTALL)/include

$(compile-host-1): $(BZIP2)
