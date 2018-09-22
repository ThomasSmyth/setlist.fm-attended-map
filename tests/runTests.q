
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
    .utl.exit[`test;1];
   ];
  t:@[;`file;{` sv'.test.instructions,'x}]("SB";1#",")0:.test.orderFile;                        / parse order file
  .log.o[`test]"successfully loaded order.txt";
  :t;                                                                                           / return order table
 };

.test.run:{
  t:.test.loadOrder[];                                                                          / get order table
  KUltf each exec file from t;                                                                  / add each instruction set
  KUrt[];                                                                                       / run tests
  if[c:0<count t:select from KUTR where not ok;                                                 / return any failed tests
    .log.e[`test]("{} tests failed";c);
    show t;
   ];
   if[not c;
    .log.o[`test]"Tests successfully passed";
   ];
  .utl.exit[`test]0<c;                                        / exit with appropriate status code
 };

.test.run[];                                                                                    / run tests
