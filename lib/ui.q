// Webpage ui code
// Required to work with json

.ui.inputs:{[dict]
  dict:.Q.def[`username`venue`h!(enlist"";enlist"";0Ni)]dict;
  if[null dict`h;:.log.e[`ui]"null handle provided"];
  dict[`exdata]:$[count raze dict`venue;`venue;`markers];
  :dict;
 };

.ui.outputs:{[dict;out]
//  `export set data;
  data:out[`data;`data];
  if[`venue=dict`exdata;data:select from data where venId in enlist dict`venue];
  data:delete id,url,lat,long,venId from update artist:.html.anchor'[url;artist]from data;
  out[`data;`data]:data;
  out[`username]:dict`username;
  :.[out;`data`time;{`int$(.z.p-x)%1000000}];
 };

.ui.exectimeit:{[dict]                                                                          / [dict] execute function and time it
  output:()!();                                                                                 / blank output
  start:.z.p;                                                                                   / set start time

  dict:.ui.inputs dict;                                                                         / parse inputs

  data:.data.attended dict;                                                                     / get attended events and cache results for a connection handle

  if[`markers=dict`exdata;output,:.data.markers[dict;data]];                                    / append markers

  output,:.ui.format[`table;(`time`rows`data)!(start;count data;data)];                         / Send formatted table
  :.ui.outputs[dict;output];
 };

.ui.format:{[name;data]                                                                         / [name;data] format dictionary to be encoded into json
    :`name`data!(name;data);
  };

.ui.execdict:{[dict]                                                                            / [params] execute request based on passed dict of parameters
  if[not`username in key dict;
    .log.e[`ui]"Username not passed";
   ];

  .log.o[`ui]"Executing query";
  data:@[.ui.exectimeit;dict;{.log.e[`ui]("Didn't execute due to {}";x)}];                      / execute query using parsed params

  .log.o[`ui]("Returning {} results";count data[`data;`data]);
  :data;
  };

.ui.evaluate:{@[.ui.execdict;x;{enlist[`error]!enlist x}]}                                      / evaluate incoming data from websocket, outputting errors to front end

/ web socket handlers
.z.ws:{                                                                                         / websocket handler
  .log.o[`ui]"handling websocket event";
  neg[.z.w] -8!.j.j .ui.format[`processing;()];
  .log.o[`ui]"processing request";
  `io set input:@[.j.k -9!x;`h;:;string .z.w];
  res:.ui.evaluate input;
  .log.o[`ui]"sending result to front end";
  neg[.z.w] -8!.j.j res;
 };
.z.wo:{
  .log.o[`ui]"new connection made";
  neg[.z.w] -8!.j.j .ui.format[`init;()];
 };
.z.wc:{
  .log.o[`ui]("websocket closed deleting cached data for handle {}";x);
  delete from`.cache.attended where h=x;
  delete from`.cache.geocode where h=x;
 };
.z.po:{                                                                                         / deny local connections
  .log.o[`ui]("Blocking incoming request on handle {}";.z.w);
  hclose .z.w;
 }:
