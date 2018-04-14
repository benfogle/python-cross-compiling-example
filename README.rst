Python Cross Compiling Example
==============================

This repository is a worked example of cross compiling a non-trivial Python app
to run on Android. It is the companion to the Python Cross-Compiling Guide (as
yet unpublished). The makefile above will download all dependencies, build
them, and produce a tarball containing:

- Python 3.6 for Android (ARM)
- numpy
- Pandas
- matplotlib
- Pillow
- Example Python scripts


Building
========

The makefile is written and tested on Ubuntu 16.04. Consult
``docker/Dockerfile`` in this repository for details of the prerequisites that
should be installed on the build machine.

To build, it should be enough to run ``make``.

To build using Docker:

.. code:: sh

    $ docker run --rm \
        -v /path/to/working:/working \
        -v /path/to/output:/output \
        -v /path/to/this/repo:/source \
        benfogle/python-cross-compiling-example

Where ``working`` is a scratch directory for intermediate build files.


Running
=======

To run, use adb to push the resulting files to the Android device. Rather than
run Python directly, which requires setting ``LD_LIBRARY_PATH``, run the script
``bin/apython``, which will set it for you. Examples are in the
``examples`` directory.

