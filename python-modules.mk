$(build-python-modules): $(crossenv)
	. $(CROSSENV_ACTIVATE) \
	&& build-pip install --upgrade pip setuptools wheel Cython numpy Tempita \
	&& cross-expose wheel setuptools
	touch $@


PILLOW_TAR := $(WORKING)/Pillow-5.0.0.tar.gz
PILLOW_EXTRACT := $(call extract,$(PILLOW_TAR))
PILLOW_WHEEL := $(WHEELS)/Pillow-5.0.0-cp36-cp36m-linux_arm.whl

$(PILLOW_TAR): $(build-python-modules)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(dir $@) \
	&& pip download --no-deps Pillow==5.0.0
	touch $@

$(PILLOW_WHEEL): $(PILLOW_EXTRACT).extracted $(build-python-modules) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(PILLOW_EXTRACT) \
	&& cross-python setup.py \
		build_ext --disable-platform-guessing \
		bdist_wheel --dist-dir=$(WHEELS)

$(host-python-wheels): $(PILLOW_WHEEL)

NUMPY_ZIP := $(WORKING)/numpy-1.14.2.zip
NUMPY_EXTRACT := $(call extract,$(NUMPY_ZIP),numpy-1.14.2)
NUMPY_WHEEL := $(WORKING)/wheels/numpy-1.14.2-cp36-cp36m-linux_arm.whl

$(NUMPY_ZIP): $(build-python-modules)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(dir $@) \
	&& pip download --no-deps numpy==1.14.2
	touch $@

$(NUMPY_WHEEL): $(NUMPY_EXTRACT).extracted \
		$(build-python-modules) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(NUMPY_EXTRACT) \
	&& cross-python setup.py build_ext --libraries m \
			bdist_wheel --dist-dir=$(WHEELS)

$(host-python-wheels): $(NUMPY_WHEEL)

PANDAS_TAR := $(WORKING)/pandas-0.22.0.tar.gz
PANDAS_EXTRACT := $(call extract,$(PANDAS_TAR))
PANDAS_WHEEL := $(WHEELS)/pandas-0.22.0-cp36-cp36m-linux_arm.whl

$(PANDAS_TAR): $(build-python-modules)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(dir $@) \
	&& pip download --no-deps Pandas==0.22.0
	touch $@

# Force this after numpy build so that cross-expose doesn't mess
# things up in a parallel build.
$(PANDAS_WHEEL): $(PANDAS_EXTRACT).extracted $(build-python-modules) \
		$(NUMPY_WHEEL) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(PANDAS_EXTRACT) \
	&& cross-expose Cython numpy Tempita \
	&& cross-python setup.py build_ext --libraries m \
			bdist_wheel --dist-dir=$(dir $@) \
	&& cross-expose -u Cython numpy Tempita

$(host-python-wheels): $(PANDAS_WHEEL)

MATPLOTLIB_TAR := $(WORKING)/matplotlib-2.2.2.tar.gz
MATPLOTLIB_EXTRACT := $(call extract,$(MATPLOTLIB_TAR))
MATPLOTLIB_WHEEL := $(WHEELS)/matplotlib-2.2.2-cp36-cp36m-linux_arm.whl

$(MATPLOTLIB_TAR): $(build-python-modules)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(dir $@) \
	&& pip download --no-deps matplotlib==2.2.2
	touch $@

$(MATPLOTLIB_WHEEL): $(MATPLOTLIB_EXTRACT).extracted $(build-python-modules) \
		$(compile-host) $(NUMPY_WHEEL) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(MATPLOTLIB_EXTRACT) \
	&& echo '[directories]' > setup.cfg \
	&& echo 'basedirlist = $(CROSS_SYSROOT)/usr,$(INSTALL)' >> setup.cfg \
	&& cross-python setup.py build_ext --libraries c++_shared,png \
		bdist_wheel --dist-dir=$(dir $@)

$(host-python-wheels): $(MATPLOTLIB_WHEEL)

$(host-python-modules): $(host-python-wheels)
	. $(CROSSENV_ACTIVATE) \
	&& pip install -I --prefix=$(INSTALL) -f $(WHEELS) \
		matplotlib==2.2.2 Pillow==5.0.0 numpy==1.14.2 pandas==0.22.0
	touch $@
