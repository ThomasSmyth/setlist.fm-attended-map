/ setlist fm mapping backend

\l cfg/settings.q
\l lib/utl.q
\l lib/log.q
\l lib/load.q
\l lib/http.q
\l lib/data.q
\l lib/html.q
\l lib/ui.q

if[`run in key .Q.opt .z.x;
  .log.o[`run]("-run specified, setting port to {}";.var.port);
  system .utl.sub("p {}";.var.port);
 ];
