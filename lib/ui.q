// Webpage ui code
// Required to work with json

.ui.exectimeit:{[dict]                                                                          / [dict] execute function and time it
  output:()!();                                                                                 / blank output
  start:.z.p;                                                                                   / set start time

  data:.data.attended dict`username;                                                            / get attended events
  markers:.data.markers data;                                                                   / get city markers

  output,:.ui.format[`table;(`time`rows`data)!(`int$(.z.p-start)%1000000;count data;data)];     / Send formatted table
  output,:enlist[`markers]!enlist markers;
  `:npo set output;
  :output;
 };

.ui.format:{[name;data]                                                                         / [name;data] format dictionary to be encoded into json
    :`name`data!(name;data);
  };

.ui.execdict:{[dict]                                                                            / [params] execute request based on passed dict of parameters
  // move init to .z.o
  if[not`username in key dict;
    .log.e("Username not passed");
   ];

  .log.o"Executing query";                                                                      / execute query using parsed params
  data:@[.ui.exectimeit;dict;{.log.e("Didn't execute due to {}";dict)}];

  .log.o("Returning {} results";count data[`data;`data]);
  :data;
  };

.ui.evaluate:{@[.ui.execdict;x;{enlist[`error]!enlist x}]}                                      / evaluate incoming data from websocket, outputting errors to front end

/ web socket handlers
.z.ws:{                                                                                         / websocket handler
  .log.o"handling websocket event";
  neg[.z.w] -8!.j.j .ui.format[`processing;()];
  .log.o"processing request";
  `io set .j.k -9!x;
  res:.ui.evaluate .j.k -9!x;
  .log.o"sending result to front end";
  neg[.z.w] -8!.j.j res;
 };
.z.wo:{
  .log.o"new connection made";
  neg[.z.w] -8!.j.j .ui.format[`init;()];
 };
.z.wc:{.log.o"websocket closed"};
