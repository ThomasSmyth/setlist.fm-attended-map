
\l setlistfm.q
\l tests/k4unit.q

.test.dir:hsym`$getenv`SFMTESTDIR;
.test.fixtures:` sv .test.dir,`fixtures;
.test.orderFile:`:tests/order.txt;
.test.order:();

.test.fixture.bin:{[d;f;n]n set get .utl.p.symbol d,f}.test.fixtures;

.test.loadOrder:{
  r:@[read0;.test.orderFile;{.log.e[`test]"order.txt not found, exiting...";exit 1}];
  .test.order:` sv'`:tests,'`$r;
  .log.o[`test]"successfully loaded order.txt";
 };

.test.run:{
  .test.loadOrder[];
  KUltf each .test.order;
  KUrt[];
  if[c:count t:select from KUTR where not ok;
    .log.e[`test]("{} tests failed";c);
    :show t;
   ];
  .log.o[`test]"Tests successfully passed";
 };

.test.run[];

if[not(count select from KUTR where not ok)&`debug in key .Q.opt .z.x;exit 0];
