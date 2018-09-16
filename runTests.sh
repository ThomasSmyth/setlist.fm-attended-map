
export SFMROOTDIR=${PWD}
export SFMTESTDIR=${PWD}/tests

if [ "$1" = "-debug" ]; then
  cmd="rlwrap -c -r q"
else
  cmd="q"
fi

$cmd $SFMTESTDIR/runTests.q
