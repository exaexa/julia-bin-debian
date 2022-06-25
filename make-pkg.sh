#!/bin/bash

# input environment (+ example)
# VERSION (1.6.3)
# JULIA_ARCH (x86_64)
# JULIA_ARCH_DIR (x64)
# DEB_ARCH (amd64)
#
# derived automatically but can be overridden:
# VERSION_BRANCH (1.6)
# DEB_VERSION (1.8.0rc1)
#
# e.g.
# VERSION=1.7.2 DEB_ARCH=amd64 JULIA_ARCH=x86_64 JULIA_ARCH_DIR=x64 ./make-pkg.sh

VERSION_BRANCH=${VERSION_BRANCH-$(echo $VERSION | cut -d. -f1-2)}
DEB_VERSION=${DEB_VERSION-$(echo $VERSION | tr -d -)}

DIR=julia-bin-$VERSION
mkdir -p $DIR/debian/source
cd $DIR

echo '3.0 (native)' > debian/source/format

cat > debian/changelog << EOF
julia-bin ($DEB_VERSION) unstable; urgency=medium

  * Built from binary source.

 -- Julia Developers <contact@julialang.org>  `date -R`
EOF

cat > debian/control << EOF
Source: julia-bin
Section: science
Priority: optional
Maintainer: Julia Developers <contact@julialang.org>
Rules-Requires-Root: no
Build-Depends:
 debhelper-compat (= 13),
Standards-Version: 4.6.1
Homepage: https://julialang.org/

Package: julia-bin
Architecture: $DEB_ARCH
Depends:
 \${misc:Depends},
Description: high-performance programming language for technical computing
 Julia is a high-level, high-performance dynamic programming language for
 technical and scientific computing with user-friendly syntax. This package is
 a repacked version of the official binaries.
EOF

cat > debian/copyright << EOF
Format: https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Source: <https://julialang.org/downloads/>
Upstream-Name: julia
Upstream-Contact: <https://julialang.org/governance/>

Files:
 *
Copyright:
 `date +%Y` Julia developers
License: MIT
 Copyright (c) 2009-`date +%Y`: Jeff Bezanson, Stefan Karpinski, Viral B. Shah, and
 other contributors: https://github.com/JuliaLang/julia/contributors
 .
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 .
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 .
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF

cat > debian/rules << EOF
#!/usr/bin/make -f

export DH_VERBOSE = 1

%:
	export DESTDIR
	dh \$@

override_dh_auto_configure:
	make source

override_dh_auto_build:
	echo "no build!"

override_dh_dwz:
	echo "no dwz!"

override_dh_link:
	echo "no linking corrections!"

override_dh_strip_nondeterminism:
	echo "nondeterminism!"

override_dh_makeshlibs:
	echo "no makeshlibs!"

override_dh_shlibdeps:
	echo "no shlibdeps!"

override_dh_strip:
	echo "no strip!"
EOF
chmod +x debian/rules

cat > Makefile << EOF
all:

source:
	wget https://julialang-s3.julialang.org/bin/linux/${JULIA_ARCH_DIR}/${VERSION_BRANCH}/julia-${VERSION}-linux-${JULIA_ARCH}.tar.gz
	tar xzf julia-${VERSION}-linux-${JULIA_ARCH}.tar.gz

install:
	mkdir -p \$(DESTDIR)/libexec
	cp -a julia-${VERSION} \$(DESTDIR)/libexec
	mkdir -p \$(DESTDIR)/bin
	ln -sf /libexec/julia-${VERSION}/bin/julia \$(DESTDIR)/bin/julia-${VERSION}
EOF

dpkg-buildpackage -us -uc
