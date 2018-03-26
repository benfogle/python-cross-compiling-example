define _download-to-file
$(1): $$(make-dirs)
	mkdir -p $$(dir $$@)
	curl -L $(2) > $$@
_retval := $(1)
endef

define download-to-file
$(eval $(call _download-to-file,$(1),$(2)))$(_retval)
endef

define download-to
$(call download-to-file,$(1)/$(notdir $(2)),$(2))
endef

define download
$(call download-to,$(WORKING),$(1))
endef

KNOWN_TAR_EXTENSIONS := %.tar.gz %.tar.bz2 %.tar.xz %.tgz %.tar

define archive-basename
$(strip \
	$(foreach ext,$(KNOWN_TAR_EXTENSIONS) %.zip,\
		$(patsubst $(ext),%,$(filter $(ext),$(notdir $(1)))) \
	) \
)
endef

define _extract-to
_base := $(if $(3),$(3),$$(call archive-basename,$(2)))
ifneq ($$(filter %.zip,$(2)),)
_cmd := unzip -qo
else ifneq ($$(filter $$(KNOWN_TAR_EXTENSIONS),$(2)),)
_cmd := tar xf
else
$$(error Don't know how to extract $(2))
endif

_retval := $(1)/$$(_base)
$$(_retval): _cmd := $$(_cmd)
$$(_retval): $(2) $$(make-dirs)
	mkdir -p $$(dir $$@)
	cd $$(dir $$@) && $$(_cmd) $$(abspath $$<)
	touch $$@

$$(_retval).extracted: | $$(_retval)
	touch $$@

endef

# 1 - destination directory
# 2 - archive path
# 3 - optional alternate archive base name. Default based on path
define extract-to
$(eval $(call _extract-to,$(1),$(2),$(3)))$(_retval)
endef

# 1 - archive path
# 2 - optional alternate archive base name. Default based on path
define extract
$(call extract-to,$(WORKING),$(1),$(2))
endef

# 1 - name
define _define-one-stage
$(1) := $$(STAGE_MARKERS)/$(1)
$(1): $$($(1))
.PHONY: $(1)
endef

define define-stage
$(foreach stage,$(1),$(eval $(call _define-one-stage,$(stage))))
endef

$(STAGE_MARKERS)/%: | $(STAGE_MARKERS)
	touch $@

