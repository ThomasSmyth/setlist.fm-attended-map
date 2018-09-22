/ custom utilities

.utl.exit:{[f;s]                                                                                / [file/function;exit code] log exit code and exit if .cfg.exit is true
  .log[`o`e s][f]("Exiting with code {}";s);
  if[.cfg.exit;exit s];
 };
