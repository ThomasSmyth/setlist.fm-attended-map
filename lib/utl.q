/ custom utilities

.utl.exit:{[f;s]                                                                                / [file/function;exit code] log exit code and exit if .cfg.exit is true
  .log[`o`e s][f]("exiting with code {}";s);
  if[.cfg.exit;exit s];
 };

.utl.args:{
  .log.o[`utl]"parsing command line";
  def:{x!.cfg x}.cfg.def;                                                                       / get defaults
  d:.Q.def[def].Q.opt .z.x;                                                                     / parse command line
  if[count c:.cfg.inputs:.cfg.def _d;                                                           / save non default values passed
    .log.o[`utl]"updating .cfg.inputs";
    .cfg.inputs:.cfg.def _d;
  ];
  if[not d~def;                                                                                 / update default configs
    .log.o[`utl]"updating config defaults";
    .cfg,:.cfg.def#d;
  ];
 };
