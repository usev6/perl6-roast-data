#!/bin/sh

## default to sysperl
PATH=/usr/local/bin:$PATH

## some tests require a LANG.
export LANG=en_US.UTF-8

# uninstalled rakudo doesn't know how to find Test.pm
# ... or any other modules
export PERL6LIB=/home/christian/perl6-roast-data/rakudo.moar/lib

## we assume an installed rakudo.moar
export RAKUDO_INSTALL_DIR=/home/christian/bin/rakudo.moar
#rm -rf ${RAKUDO_INSTALL_DIR}/*
PATH=${RAKUDO_INSTALL_DIR}/bin:$PATH

cd rakudo.moar
git clone --recursive git://github.com/tadzik/panda.git
cd panda
perl6 bootstrap.pl
PATH=${RAKUDO_INSTALL_DIR}/languages/perl6/site/bin:$PATH
export PERL6LIB=/home/christian/bin/rakudo.moar/languages/perl6/site:ext/File__Find/lib:ext/Shell_Command/lib:ext/JSON__Tiny/lib:lib
panda --exclude=Test::ClientServer smoke 2>&1 | tee ../../panda.moar_summary.out
