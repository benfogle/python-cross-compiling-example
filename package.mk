PACKAGE_WORKING := $(TOP)/package
PACKAGE := $(TOP)/package.tar
FIXUP := $(TOP)/fixup.py

$(package): $(PACKAGE)
$(PACKAGE): $(host-python-modules)
	rm -rf $(PACKAGE_WORKING)
	cp -rd $(INSTALL) $(PACKAGE_WORKING)
	$(BUILD_PYTHON) $(FIXUP) $(PACKAGE_WORKING) $(TOOLCHAIN_BIN)/$(CROSS_STRIP)
	tar -C $(dir $(PACKAGE_WORKING)) -cf $@ $(notdir $(PACKAGE_WORKING)) \
		--exclude=*.la \
		--exclude=*.a \
		--exclude=test \
		--exclude=tests \
		--exclude=man \
		--exclude=pkgconfig \
		--transform='s!^[.]/!package/!'
