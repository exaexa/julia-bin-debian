
# Package official julia releases into Debian packages

Te script `make-pkg.jl` creates a julia .deb (and some other things) in the
current directory. It needs a debian with some tools, such as debhelper and
devscripts.

Make sure to clean the directory before building the same version again,
otherwise weird stuff happens.

Input environment (+ example):
- `VERSION` (`1.6.3`)
- `JULIA_ARCH` (`x86_64`)
- `JULIA_ARCH_DIR` (`x64`)
- `DEB_ARCH` (`amd64`)

Derived automatically that can be overridden automatically
- `VERSION_BRANCH` (`1.6`)
- `DEB_VERSION` (`1.8.0rc1`)

Example:
```
VERSION=1.7.3 DEB_ARCH=amd64 JULIA_ARCH=x86_64 JULIA_ARCH_DIR=x64 ./make-pkg.sh
```

Again, do not forget to remove tempfiles before each build. Use `git clean
-fdx` or so.

