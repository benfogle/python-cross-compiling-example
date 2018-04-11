PACKAGE := $(OUTPUT)/package.tar

$(package): $(PACKAGE)
$(PACKAGE): $(host-python-modules) $(examples)
	tar -C $(dir $(INSTALL)) -cf $@ $(notdir $(INSTALL)) \
		--exclude=*.la \
		--exclude=*.a \
		--exclude=test \
		--exclude=tests \
		--exclude=man \
		--exclude=pkgconfig \
		--exclude=include \
		--transform='s!^[.]/!package/!'


clean: clean-package

.PHONY: clean-package
clean-package:
	rm -rf $(PACKAGE)
