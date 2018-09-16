
\l setlistfm.q
\l tests/k4unit.q

.test.dir:hsym`$getenv`SFMTESTDIR;
.test.instructions:` sv .test.dir,`instructions
.test.orderFile:`:tests/order.csv;

/ fixtures
.test.fixture.dir:` sv .test.dir,`fixtures;
.test.fixture.vars:();

.test.fixture.bin:{[d;f;n]
  if[n in .test.fixture.vars;                                                                   / check for duplicate fixture name
    .log.e[`test]("var exists: {}";n);
    '.utl.sub("var exists: {}";n);
   ];
  if[()~key p:.utl.p.symbol d,f;                                                                / check fixture file exists
    .log.e[`test]("file does not exist: {}";p);
    '.utl.sub("file does not exist: {}";p);
   ];
  n set get p;                                                                                  / add fixture
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
  if[()~key .test.orderFile;                                                                    / ensure order file exists
    .log.e[`test]"order.txt not found, exiting...";
    exit 1;
   ];
  t:@[;`file;{` sv'.test.instructions,'x}]("SB";1#",")0:.test.orderFile;                        / parse order file
  .log.o[`test]"successfully loaded order.txt";
  :t;                                                                                           / return order table
 };

.test.run:{
  t:.test.loadOrder[];                                                                          / get order table
  KUltf each exec file from t;                                                                  / add each instruction set
  KUrt[];                                                                                       / run tests
  if[c:count t:select from KUTR where not ok;                                                   / return any failed tests
    .log.e[`test]("{} tests failed";c);
    :show t;
   ];
  .log.o[`test]"Tests successfully passed";
 };

.test.run[];

if[not(count select from KUTR where not ok)&`debug in key .Q.opt .z.x;                          / do not exit if an error occurs in debug mode
  exit 0;
 ];
