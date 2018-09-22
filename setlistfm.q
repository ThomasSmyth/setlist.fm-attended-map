/ setlist fm mapping backend

\l qlib/lib/utl.q
\l qlib/lib/log.q
\l qlib/lib/load.q

.load.dir.q'[`:lib`:cfg];                                                                       / load libraries and configs

if[`run in key .Q.opt .z.x;
  .log.o[`run]("-run specified, setting port to {}";.cfg.port);
  system .utl.sub("p {}";.cfg.port);
 ];
