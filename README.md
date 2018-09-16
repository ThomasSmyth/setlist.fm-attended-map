# setlist.fm user attended mapper

Map attended sets for a user, currently supports mapping venues.

Tested on kdb+ v3.4 2016.10.10.

## Operation

Entered usernames are transferred via websockets to a kdb back end that will
check setlist.fm for attended events. If the user does not exist an error is
thrown.

The setlist.fm api currently only returns the coordinates of the city a venue
is located in. This data is supplemented by geocoding the venue information
using the [nominatim](https://nominatim.openstreetmap.org/) API. If the
coordinates cannot be found then the city location will be used instead.

To reduce the number of requests to both APIs caching is implemented on a per
connection handle basis. Once a user disconnects any data they were viewing is
released from memory. No on-disk caching is implemented.

## Running

Requires:

* kdb+ v3.0+ (for websockets).
* Valid setlist.fm API key.

To run:
```
q setlistfm.q -run
```

Opens webpages on `localhost:5600/setlistfm-mapper.html`

## Tests

Testing is handled by `tests/k4unit.q`, which loads the test csvs specified in
`tests/order.csv`. This should include the relative path to the test csv within
the `tests` directory. To run the offline tests use:
```
sh runTests.sh
```

To investigate errors when running the tests the `-debug` flag can be specified
to ensure the process does not exit after encountering a failure.
```
sh runTests.sh -debug
```
