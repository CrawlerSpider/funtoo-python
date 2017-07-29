# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit eutils distutils-r1

DESCRIPTION="Python library to extract data from XML/HTML"
HOMEPAGE="https://github.com/scrapy/parsel"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND="
    >=dev-python/six-1.9.0[${PYTHON_USEDEP}]
    >=dev-python/lxml-3.4.4[${PYTHON_USEDEP}]
    >=dev-python/cssselect-0.9.1[${PYTHON_USEDEP}]
    >=dev-python/w3lib-1.15.0[${PYTHON_USEDEP}]
    dev-python/pytest-runner[${PYTHON_USEDEP}]"


DEPEND="
    dev-python/setuptools[${PYTHON_USEDEP}]
    doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
    test? ( dev-python/lxml[${PYTHON_USEDEP}]
            dev-python/pytest[${PYTHON_USEDEP}] )"

pkg_setup() {
    use doc && local HTML_DOCS=( docs/_build/html/. )
}

src_prepare() {
    # prevent non essential d'load of files in doc build
    sed -e 's:intersphinx_:#&:' -i docs/conf.py || die
    distutils-r1_src_prepare
}

src_compile() {
    distutils-r1_src_compile
    if use doc; then
        esetup.py build_sphinx || die
    fi
}

python_test() {
    "${PYTHON}" ${PN}/tests.py -v || die "Tests fail with ${EPYTHON}"
}

