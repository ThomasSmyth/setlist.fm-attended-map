// Webpage ui code
// Required to work with json

.ui.exectimeit:{[dict]                                                                          / [dict] execute function and time it
  output:()!();                                                                                 / blank output
  start:.z.p;                                                                                   / set start time

  data:.data.attended dict;                                                                     / get attended events and cache results for a connection handle
//  `export set data;
  data:delete url from update artist:.html.anchor'[url;artist]from data;                        / link to event
  markers:.data.markers[dict;data];                                                             / get city markers

  output,:.ui.format[`table;(`time`rows`data)!(`int$(.z.p-start)%1000000;count data;data)];     / Send formatted table
  output,:markers;
  output[`username]:dict`username;
  `:npo set output;
  :output;
 };

.ui.format:{[name;data]                                                                         / [name;data] format dictionary to be encoded into json
    :`name`data!(name;data);
  };

.ui.execdict:{[dict]                                                                            / [params] execute request based on passed dict of parameters
  if[not`username in key dict;
    .log.e("Username not passed");
   ];

  .log.o"Executing query";                                                                      / execute query using parsed params
  data:@[.ui.exectimeit;dict;{.log.e("Didn't execute due to {}";x)}];

  .log.o("Returning {} results";count data[`data;`data]);
  :data;
  };

.ui.evaluate:{@[.ui.execdict;x;{enlist[`error]!enlist x}]}                                      / evaluate incoming data from websocket, outputting errors to front end

/ web socket handlers
.z.ws:{                                                                                         / websocket handler
  .log.o"handling websocket event";
  neg[.z.w] -8!.j.j .ui.format[`processing;()];
  .log.o"processing request";
  input:enlist[`]!enlist(::);
  `io set input,:@[.j.k -9!x;`h;:;.z.w];
  res:.ui.evaluate input;
  .log.o"sending result to front end";
  neg[.z.w] -8!.j.j res;
 };
.z.wo:{
  .log.o"new connection made";
  neg[.z.w] -8!.j.j .ui.format[`init;()];
 };
.z.wc:{
  .log.o("websocket closed deleting cached data for handle {}";x);
  delete from`.cache.attended where h=x;
  delete from`.cache.geocode where h=x;
 };
.z.po:{                                                                                         / deny local connections
  .log.o("Blocking incoming request on handle {}";.z.w);
  hclose .z.w;
 }:
