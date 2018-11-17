CROSSENV := $(WORKING)/crossenv
CROSSENV_ACTIVATE := $(CROSSENV)/bin/activate
ENV_CROSS_PYTHON := $(CROSSENV)/cross/bin/python
ENV_CROSS_PIP := $(CROSSENV)/cross/bin/pip
ENV_BUILD_PYTHON := $(CROSSENV)/build/bin/python
ENV_BUILD_PIP := $(CROSSENV)/build/bin/pip
ENV_CROSS_EXPOSE := $(CROSSENV)/bin/cross-expose
CROSSENV_PATH := git+https://github.com/benfogle/crossenv.git

$(CROSSENV_ACTIVATE): $(build-python-interp) $(host-python-interp)
	$(BUILD_PYTHON) -m pip install $(CROSSENV_PATH)
	PATH=$(COMPILE_HOST_PATH) \
		 $(BUILD_PYTHON) -m crossenv \
			--sysroot=$(CROSS_SYSROOT) \
			--env=CPATH:=$(INSTALL)/include \
			--env=LIBRARY_PATH:=$(INSTALL)/lib \
			--env=PATH:=$(TOOLCHAIN_BIN) \
			--env=PKG_CONFIG_LIBDIR=$(CROSS_PKG_CONFIG_LIBDIR) \
			--clear \
			$(HOST_PYTHON) \
			$(CROSSENV)

$(crossenv): $(CROSSENV_ACTIVATE)
