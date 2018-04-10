APYTHON := $(INSTALL)/bin/apython
$(APYTHON): $(TOP)/apython
	install -m 755 $< $@

EXAMPLES_SRC := $(wildcard $(TOP)/examples/*)
EXAMPLES_DST := $(addprefix $(INSTALL)/examples/,$(notdir $(EXAMPLES_SRC)))
$(INSTALL)/examples/%: $(TOP)/examples/%
	cp -rdf $< $@

# Just put these somewhere before packaging
$(examples): $(APYTHON) $(EXAMPLES_DST)
