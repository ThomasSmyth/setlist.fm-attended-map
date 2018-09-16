
\l setlistfm.q
\l tests/k4unit.q

.test.orderFile:`:tests/order.txt;
.test.order:();

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
