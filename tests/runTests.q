
\l setlistfm.q
\l tests/k4unit.q

.test.dir:hsym`$getenv`SFMTESTDIR;
.test.orderFile:`:tests/order.csv;

/ fixtures
.test.fixture.dir:` sv .test.dir,`fixtures;
.test.fixture.vars:();

.test.fixture.bin:{[d;f;n]
  if[n in .test.fixture.vars;
    .log.e[`test]("var exists: {}";n);
    '.utl.sub("var exists: {}";n);
   ];
  p:.utl.p.symbol d,f;
  if[()~key p:.utl.p.symbol d,f;
    .log.e[`test]("file does not exist: {}";p);
    '.utl.sub("file does not exist: {}";p);
   ];
  n set get p;
  .test.fixture.vars,:n;                                                                        / add variable to list
 }.test.fixture.dir;

.test.fixture.clear:{                                                                           / remove added fixtures
  {
    :![;();0b;].$[3=count l:` vs x;(` sv l 0 1;enlist l 2);(`.;enlist x)];                      / ensure fixtures are removed from namespaces
  }'[.test.fixture.vars];
  .test.fixture.vars:();                                                                        / clear fixture list
 };

/ tests
.test.loadOrder:{
  if[()~key .test.orderFile;
    .log.e[`test]"order.txt not found, exiting...";
    exit 1;
   ];
  t:@[;`file;{` sv'.test.dir,'x}]("SB";1#",")0:.test.orderFile;
  .log.o[`test]"successfully loaded order.txt";
  :t;
 };

.test.run:{
  t:.test.loadOrder[];
  KUltf each exec file from t;
  KUrt[];
  if[c:count t:select from KUTR where not ok;
    .log.e[`test]("{} tests failed";c);
    :show t;
   ];
  .log.o[`test]"Tests successfully passed";
 };

.test.run[];

if[not(count select from KUTR where not ok)&`debug in key .Q.opt .z.x;
  exit 0;
 ];
