#!/bin/sh

# default to sysperl
PATH=/usr/local/bin:$PATH

RAKUDO_INSTALL_DIR=/home/christian/bin/rakudo.moar
rm -rf ${RAKUDO_INSTALL_DIR}/*

rm -rf rakudo.moar
git clone repos/rakudo.git rakudo.moar
git clone repos/nqp.git rakudo.moar/nqp
git clone repos/MoarVM.git rakudo.moar/nqp/MoarVM
git clone repos/roast.git rakudo.moar/t/spec
cd rakudo.moar
#perl Configure.pl --gen-moar --gen-nqp --backends=moar
perl Configure.pl --gen-moar --gen-nqp --backends=moar --prefix=${RAKUDO_INSTALL_DIR}
make -j 2 all

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=$(pwd)/lib

# some tests require a LANG.
export LANG=en_US.UTF-8

# swap out the default runner with one that is ulimited
echo "#!/usr/bin/env perl" > perl6
echo 'exec "ulimit -t 120; ulimit -v 2500000; ulimit -c 0; nice -20 ./perl6-m @ARGV"' >> perl6
chmod a+x ./perl6

perl t/spec/test_summary rakudo.moar 2>&1 | tee ../log/rakudo.moar_summary.out

## preparation for panda smoking
make install
