APYTHON := $(INSTALL)/bin/apython
$(APYTHON): $(TOP)/apython
	install -m 755 $< $@

# Just put these somewhere before packaging
$(host-python-modules): $(APYTHON)
