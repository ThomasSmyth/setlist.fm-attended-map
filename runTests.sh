
export SFMROOTDIR=${PWD}
export SFMTESTDIR=${PWD}/tests

arg=""

if [ "$1" = "-debug" ]; then
  arg="-debug"
fi

rlwrap -c -r q $SFMTESTDIR/runTests.q $arg
