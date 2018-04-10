PACKAGE_WORKING := $(TOP)/package
PACKAGE := $(TOP)/package.tar

$(package): $(PACKAGE)
$(PACKAGE): $(host-python-modules) $(examples)
	rm -rf $(PACKAGE_WORKING)
	cp -rd $(INSTALL) $(PACKAGE_WORKING)
	tar -C $(dir $(PACKAGE_WORKING)) -cf $@ $(notdir $(PACKAGE_WORKING)) \
		--exclude=*.la \
		--exclude=*.a \
		--exclude=test \
		--exclude=tests \
		--exclude=man \
		--exclude=pkgconfig \
		--transform='s!^[.]/!package/!'


clean: clean-package

.PHONY: clean-package
clean-package:
	rm -rf $(PACKAGE) $(PACKAGE_WORKING)
