/ data processing

.cache.attended:()!();

.data.attended:{[id]                                                                            / [id] get attended events for a user, checking for cached events;
  if[first enlist[id]in key .cache.attended;
    .log.o("Returning cached results for {}";id);
    :.cache.attended id;
  ];
  .log.o("No cached results for {}";id);
  .cache.attended,:enlist[id]!enlist res:.http.attended id;
  :res;
 };

.data.markers:{[data]                                                                           / requires city,lat,long columns
  m:distinct data[;`city`lat`long];
  :`markers`bounds!(m;(min;max)@\:m[;1 2]);
 };
