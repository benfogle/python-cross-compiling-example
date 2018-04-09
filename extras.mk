APYTHON := $(INSTALL)/bin/apython
$(APYTHON): $(TOP)/apython
	install -m 755 $< $@

EXAMPLES_SRC := $(wildcard $(TOP)/examples/*)
EXAMPLES := $(addprefix $(INSTALL)/examples/,$(notdir $(EXAMPLES_SRC)))
$(INSTALL)/examples/%: $(TOP)/examples/% | $(INSTALL)/examples
	cp -df $< $@
	
$(INSTALL)/examples:
	mkdir -p $@

# Just put these somewhere before packaging
$(host-python-modules): $(APYTHON) $(EXAMPLES)
