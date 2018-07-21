# To download packages, we use direct URLs from PyPI. We could have used "pip
# download" as well, but that runs "python setup.py egg_info" on the downloaded
# package. In the case of matplotlib and maybe others, this triggers a
# dependency check that fails because we can't give this command arguments.

$(build-python-modules): $(crossenv)
	. $(CROSSENV_ACTIVATE) \
	&& build-pip install wheel Cython numpy Tempita \
	&& cross-expose wheel setuptools
	touch $@

PYTHON_SHLIBS := m,compiler_rt-extras

PILLOW_URL := https://pypi.python.org/packages/0f/57/25be1a4c2d487942c3ed360f6eee7f41c5b9196a09ca71c54d1a33c968d9/Pillow-5.0.0.tar.gz
PILLOW_TAR := $(call download,$(PILLOW_URL))
PILLOW_EXTRACT := $(call extract,$(PILLOW_TAR))
PILLOW_WHEEL := $(WHEELS)/Pillow-5.0.0-cp36-cp36m-linux_arm.whl

$(PILLOW_WHEEL): $(PILLOW_EXTRACT).extracted $(build-python-modules) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(PILLOW_EXTRACT) \
	&& cross-python setup.py \
		build_ext --disable-platform-guessing \
		bdist_wheel --dist-dir=$(WHEELS)

$(host-python-wheels): $(PILLOW_WHEEL)

NUMPY_URL := https://pypi.python.org/packages/0b/66/86185402ee2d55865c675c06a5cfef742e39f4635a4ce1b1aefd20711c13/numpy-1.14.2.zip
NUMPY_ZIP := $(call download,$(NUMPY_URL))
NUMPY_EXTRACT := $(call extract,$(NUMPY_ZIP),numpy-1.14.2)
NUMPY_WHEEL := $(WORKING)/wheels/numpy-1.14.2-cp36-cp36m-linux_arm.whl

$(NUMPY_WHEEL): $(NUMPY_EXTRACT).extracted \
		$(build-python-modules) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(NUMPY_EXTRACT) \
	&& cross-python setup.py build_ext --libraries $(PYTHON_SHLIBS) \
			bdist_wheel --dist-dir=$(WHEELS)

$(host-python-wheels): $(NUMPY_WHEEL)

PANDAS_URL := https://pypi.python.org/packages/08/01/803834bc8a4e708aedebb133095a88a4dad9f45bbaf5ad777d2bea543c7e/pandas-0.22.0.tar.gz
PANDAS_TAR := $(call download,$(PANDAS_URL))
PANDAS_EXTRACT := $(call extract,$(PANDAS_TAR))
PANDAS_WHEEL := $(WHEELS)/pandas-0.22.0-cp36-cp36m-linux_arm.whl

# Force this after numpy build so that cross-expose doesn't mess
# things up in a parallel build.
$(PANDAS_WHEEL): $(PANDAS_EXTRACT).extracted $(build-python-modules) \
		$(NUMPY_WHEEL) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(PANDAS_EXTRACT) \
	&& cross-expose Cython numpy Tempita \
	&& cross-python setup.py build_ext --libraries $(PYTHON_SHLIBS) \
			bdist_wheel --dist-dir=$(dir $@) \
	&& cross-expose -u Cython numpy Tempita

$(host-python-wheels): $(PANDAS_WHEEL)

MATPLOTLIB_URL := https://pypi.python.org/packages/ec/ed/46b835da53b7ed05bd4c6cae293f13ec26e877d2e490a53a709915a9dcb7/matplotlib-2.2.2.tar.gz
MATPLOTLIB_TAR := $(call download,$(MATPLOTLIB_URL))
MATPLOTLIB_EXTRACT := $(call extract,$(MATPLOTLIB_TAR))
MATPLOTLIB_WHEEL := $(WHEELS)/matplotlib-2.2.2-cp36-cp36m-linux_arm.whl
MATPLOTLIB_EXAMPLES := $(INSTALL)/examples/matplotlib

$(MATPLOTLIB_WHEEL): $(MATPLOTLIB_EXTRACT).extracted $(build-python-modules) \
		$(compile-host) $(NUMPY_WHEEL) | $(WHEELS)
	. $(CROSSENV_ACTIVATE) \
	&& cd $(MATPLOTLIB_EXTRACT) \
	&& echo '[directories]' > setup.cfg \
	&& echo 'basedirlist = $(CROSS_SYSROOT)/usr,$(INSTALL)' >> setup.cfg \
	&& echo '[rc_options]' >> setup.cfg \
	&& echo 'backend = Agg' >> setup.cfg \
	&& cross-python setup.py build_ext --libraries $(PYTHON_SHLIBS),c++_shared,png \
		bdist_wheel --dist-dir=$(dir $@)

$(MATPLOTLIB_EXAMPLES): $(MATPLOTLIB_EXTRACT).extracted
	rm -rf $@
	cp -r $(MATPLOTLIB_EXTRACT)/examples $@
	find $@ -name '*.py' | \
		xargs sed -i 's/plt\.show()/plt.savefig("example.png")/'
	find $@ -name '*.py' | \
		xargs sed -i '$$aprint("Output in example.png")'

$(host-python-wheels): $(MATPLOTLIB_WHEEL)
$(examples): $(MATPLOTLIB_EXAMPLES)

$(host-python-modules): $(host-python-wheels)
	. $(CROSSENV_ACTIVATE) \
	&& pip install -I --prefix=$(INSTALL) -f $(WHEELS) \
		matplotlib==2.2.2 Pillow==5.0.0 numpy==1.14.2 pandas==0.22.0
	touch $@
