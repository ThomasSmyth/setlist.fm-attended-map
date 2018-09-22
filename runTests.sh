
export SFMROOTDIR=${PWD}
export SFMTESTDIR=${PWD}/tests

rlwrap -c -r q $SFMTESTDIR/runTests.q $arg $@
