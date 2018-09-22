/ setlist fm mapping backend

\l qlib/lib/utl.q
\l qlib/lib/log.q
\l qlib/lib/load.q

.load.dir.q'[`:lib`:cfg];                                                                       / load libraries and configs

.utl.args[];                                                                                    / parse command line

if[.cfg.run;
  .log.o[`run](".cfg.run is true, setting port to {}";.cfg.port);
  system .utl.sub("p {}";.cfg.port);
 ];
