
export SFMROOTDIR=${PWD}
export SFMTESTDIR=${PWD}/tests

if [ "$1" = "-debug" ]; then
  cmd="rlwrap -c -r q"
  arg="-debug"
else
  cmd="q"
  arg=""
fi

$cmd $SFMTESTDIR/runTests.q $arg
