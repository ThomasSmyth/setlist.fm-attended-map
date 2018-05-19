/ http request functions

.http.key:@[{first read0 x};`:cfg/setlistfm.key;{-1 x;exit 0}];

.http.root:"https://api.setlist.fm/rest/1.0/";
.http.cmd:{.utl.sub("curl -sX GET --header 'Accept: application/json' --header 'x-api-key: {}' ";.http.key)};

.http.req:{[url;params].j.k raze system .http.cmd[],.http.root,url,"?",.http.urlencode params};

.http.hu:.h.hug .Q.an,"-.~";                                                                    / URI escaping for non-safe chars, RFC-3986

.http.urlencode:{[d]                                                                            / [dict of params]
  v:enlist each .http.hu each{$[10=type x;;string]x}'[v:value d];                               / string any values that aren't stringed,escape any chars that need it
  k:enlist each$[all 10=type'[k];;string]k:key d;                                               / if keys aren't strings, string them
  :raze"&"sv\:"="sv'k,'v;                                                                       / return urlencoded form of dictionary
 };

.http.attended:{[id]                                                                            / [id] get attended events for a user
  .log.o("Requesting events for {}";id);
  :{[id;p]                                                                                      / [id;(results;page number;complete)] return all attended events for a user
    if[p 2;                                                                                     / exit if all results have been obtained
      .log.o("Found all events for {}";id);
      :p;
    ];
    c:count p 0;                                                                                / get current number of events
    .log.o("Requesting event page {} for {}";(p 1;id));
    res:.http.req[.utl.sub("user/{}/attended";id);enlist[`p]!enlist p 1];                       / request attended events
    p[0],:raze .fmt.attended'[res`setlist];                                                     / format json into table
    p[2]:(count[p 0]>="j"$res`total)or c=count p 0;                                             / determine if all results have been retrieved or requests have been exhausted
    :@[p;1;+;not p 2];                                                                          / increment page number if more data needs retrieved
  }[id]/[(();1;0b)]0;
 };

.fmt.attended:{
  artist:`date xcol enlist`eventDate`artist`url#@[x;`artist;@[;`name]];                         / get artist info
  venue:`venue xcol enlist((),`name)#x`venue;                                                   / get venue name
  city:`city xcol enlist`name`state`stateCode#x[`venue;`city];                                  / get city info
  coords:enlist x[`venue;`city;`coords];                                                        / get city coords
  country:`code`country xcol enlist x[`venue;`city;`country];                                   / get country info
  r:(,'/)(artist;venue;city;coords;country);                                                    / join sub tables
  :{@[x;y;z$]}/[r;`date`stateCode`code;"DSS"];                                                  / convert types
 };
