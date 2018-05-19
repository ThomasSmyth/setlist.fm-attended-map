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

.data.markers:{[data]
  :distinct select city,coord:(lat,'long) from data;
 };
