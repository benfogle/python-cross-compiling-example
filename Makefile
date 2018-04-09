TOP_MAKEFILE := $(abspath $(lastword $(MAKEFILE_LIST)))
TOP := $(patsubst %/,%,$(dir $(TOP_MAKEFILE)))
functions_mk := $(TOP)/functions.mk
all:

INSTALL := $(TOP)/install
WORKING := $(TOP)/working
WHEELS := $(WORKING)/wheels
STAGE_MARKERS := $(WORKING)/stages

include $(functions_mk)

$(call define-stage,\
	make-dirs \
	host-toolchain \
	compile-host-1 \
	compile-host-2 \
	compile-host \
	build-python-interp \
	host-python-interp \
	crossenv \
	build-python-modules \
	host-python-wheels \
	host-python-modules \
	package \
	)

sub_makes := $(filter-out $(functions_mk),$(wildcard $(TOP)/*.mk))
include $(sub_makes)

all: $(package)

$(compile-host): $(compile-host-2)
$(compile-host-2): $(compile-host-1)

$(make-dirs): | $(INSTALL) $(INSTALL)/bin $(INSTALL)/lib $(INSTALL)/include \
		$(WORKING) $(WHEELS) $(STAGE_MARKERS) $(INSTALL)/examples

$(INSTALL) $(INSTALL)/bin $(INSTALL)/lib $(INSTALL)/include \
		$(WORKING) $(WHEELS) $(STAGE_MARKERS) $(INSTALL)/examples:
	mkdir -p $@


clean:
	rm -rf $(WORKING) $(WHEELS) $(STAGE_MARKERS) $(INSTALL)
