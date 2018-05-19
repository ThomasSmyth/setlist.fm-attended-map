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

.data.geocode:{[params]
  res:.http.req.nominatim params;
  if[0h=type res;:`lat`long!0n 0n];
  :`lat`long!raze"F"$res`lat`lon;
 };

.data.markers:{[data]                                                                           / requires city,lat,long columns
  city:distinct select city,venue,state,country,lat,long from data;                             / select city coordinates
  ven:update q:", "sv/:flip(venue;city;state;country),limit:1 from city;                        / find venue coordinates, if they exists
  ven:ven,'.data.geocode'[`q`limit#ven];                                                        / geocode venues
  ven:0!(^/)`venue`city`country xkey/:`venue`city`country`lat`long#/:(city;ven);                / join results, filling null venue coords with city values
  m:distinct ven[;`venue`lat`long];
  :`markers`bounds!(m;(min;max)@\:m[;1 2]);
 };
