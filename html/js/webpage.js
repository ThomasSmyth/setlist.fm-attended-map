// Setlist.FM mapping tool

// Helper functions
// Format json data into HTML table
function jsonTable(data){
  var table,prop,key,row;
  if(data.length === 0){ return false; }

  table = '<table class="table table-striped table-hover">';
  table+= '<thead>';
  for(prop in data[0]){ // Column Headers
    if (data[0].hasOwnProperty(prop)) {
      table+= '<th>' + prop + '</th>';
    }
  }
  table+= '</thead><tbody>';
  for(key in data){ // Each row
    if (data.hasOwnProperty(key)) {
      table+= '<tr>';
      row = data[key];
      for(prop in row){
        if (row.hasOwnProperty(prop)) {
          table+= '<td>' + row[prop] + '</td>';
        }
      }
      table+= '</tr>';
    }
  }
  table+= '</tbody></table>';
  return table;
}
// Returns array of checkbox values depending on if "All" option is checked
function checkboxVals(selector){
  var array = [], $parent = $(selector), $inputs = $parent.find('input');
  // If all is not checked, grab the values that are checked, otherwise return empty array
  // Includes the optimization, if all inputs are checked (except "All"), this is the same as if
  // "All" was selected, therefore return empty array
  if($parent.find('input[value="all"]:checked').length === 0){
    if($parent.find('input[value!="all"]:checked').length < $inputs.length - 1){
      $parent.find('input[value!="all"]:checked').each(function(a,b){array.push($(b).val());});
    }
  }
  return array;
}

// Returns an object of all inputs used for the query
function getInputs() {
  var startdate     = $('#startdate input').val(),
      enddate       = $('#enddate input').val(),
      username      = $('#username input').val(),
      athlete_Id    = $('#athleteId').val()
      clubvals      = [],
      following     = [],
      include_map   = [],
      summary       = [],
      include_clubs = [],

  // Add values from grouping,region & custtype filter to their respective array
  $('#summary .checklist input:checked').each(function(a,b){summary.push($(b).val());});
  $('#following .checklist input:checked').each(function(a,b){following.push($(b).val());});
  $('#include_clubs .checklist input:checked').each(function(a,b){include_clubs.push($(b).val());});
  $('#include_map .checklist input:checked').each(function(a,b){include_map.push($(b).val());});

  // Add checkbox values to appropriate array depending on whether "All" option is checked
  clubvals = checkboxVals('#clubs-filter');
  athletevals = checkboxVals('#athlete-filter');

  return {
    after: startdate,
    before: enddate,
    username: username,
    club_id: clubvals,
    athlete_id: athletevals,
    summary: summary,
    following: following,
    include_clubs: include_clubs,
    include_map: include_map,
  }
}

function showMap(){

  window.map = L.map('map');

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

}

function clearMap() {
  map.eachLayer(function (layer) {
      map.removeLayer(layer);
  });

  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

}

function get_random_colour() {
  var letters = '0123456789ABCDEF'.split('');
  var colour = '#';
  for (var i = 0; i < 6; i++ )
  {
     colour += letters[Math.round(Math.random() * 15)];
  }
  return colour;
}

function plotMarkers(athlete, markArray){
  // loop over each marker and add to map
  marksLayerGroup = L.layerGroup();

  markArray.forEach(function(mark){
    marksLayerGroup.addLayer(L.marker([mark[0],mark[1]]).bindPopup(mark[2])).addTo(map);
  });

  layerControl.addOverlay(marksLayerGroup, athlete.concat(" markers"));

}


// WEBSOCKETS CONNECTING TO KDB+
var ws = new WebSocket("ws://localhost:5600");
ws.binaryType = 'arraybuffer'; // Required by c.js
// WebSocket event handlers
ws.onopen = function () {
  $('#connecting').hide();
};
ws.onclose = function () {
  // Disable submit button
  $(this).attr("disabled",true);
  // Disable export button
  $('#export').addClass("disabled");
};
ws.onmessage = function (event) {
  if(event.data){
    var edata = JSON.parse(deserialize(event.data)),
        name  = edata.name,
        data  = edata.data,
        markers = edata.markers,
        bounds = edata.bounds;

    // Enable submit button
    $('#submit').attr("disabled",false);
    $('#map_placeholder').hide();

    // Map handling functionality
    if(edata.hasOwnProperty('plottype')){

      $('#map_placeholder').show();
      $('#map_placeholder').html("").append('<div id="map"></div>');

      if(plottype === 'markers'){
        plotMarkers(markers);
      }

    }

    // Data handling functionality
    // Print database and table stats, and output table. Display error.
    if(edata.hasOwnProperty('data')){

      // Initial data about the database
      if(name === 'init'){
        // stylise field val into field: val
        $('#processing').hide();
        $('#summary').show();
        $('#include_map').show();
      }

      // Output table data
      if(name === 'table'){

        // Build html table with data and fill in stats
        $('#processing').hide();
        $('#tableoutput').show();
        $('#tableoutput').html(jsonTable(data.data));
        $('#tblstats').html("").append('<li>Date Range: ' + getInputs().startdate + " to " + getInputs().enddate +'</li>' +
          '<li>Generated in: ' + (data.time/1000).toFixed(1) + "s" +'</li>' +
          '<li>Rows: ' + data.rows +'</li>');

        // Show stats bar
        $('.stats').show();
//        $('#segName').hide();

        // Enable export link
        $('#export').removeClass("disabled");

        // Resize table cells
        //$('#tableoutput tbody td, #tableoutput thead th').width($('#tableoutput').width()/$('#tableoutput thead th').length-10);
      }

    } else {
      $('#processing').hide();
      $('#error-msg').html(edata.error);
      // Show modal popup
      $('#error-modal').modal();
    }
  }
};
ws.error = function (error) {
  // hide processing
  $('#processing').hide();
  // Enable submit button
  $('#submit').attr("disabled",false);
  // Write error message
  $('#error-msg').html(error.data);
  // Show modal popup
  $('#error-modal').modal();
}

// jQuery used for UI
$(function() {

  // Add calendar for start,end date
  $('#startdate').datepicker();
  $('#enddate').datepicker();

  // Filter options
  // This is a UI design pattern for when there is a list of multiple options for when at least
  // one option is required.
  // The "All" option is checked by default, when another option is selected the "All" option
  // is unchecked.
  // If the "All" option is checked, then all other options will be unchecked
  $('.multi-select-checkbox').each( function () {
    $(this).find('input[value!="all"]').click( function () {
      var $parent = $(this).closest('.multi-select-checkbox');
      if($parent.find('input[value!="all"]:checked').length){
        $parent.find('input[value="all"]').prop('checked', false);
      } else {
        $parent.find('input[value="all"]').prop('checked', true)
      }
    })
  });
  $('.multi-select-checkbox').each( function () {
    $(this).find('input[value="all"]').click( function () {
      $(this).closest('.multi-select-checkbox').find('input[value!="all"]').prop('checked', false);
    });
  });

  // When submit button is clicked, disabled buttons and send data over WebSocket
  $('#submit').click(function(){
    // Disable submit button on submit
    $(this).attr("disabled",true);
    $('#processing').show();
    // Disable export on submit
    $('#export').addClass("disabled");
    // Send to kdb+ over websockets
    ws.send(serialize(JSON.stringify(getInputs())));
  });
});
