var hark = require('hark')

var getUserMedia = require('getusermedia')

getUserMedia(function(err, stream) {
  if (err) throw err

  var options = {};
  var speechEvents = hark(stream, options);

  speechEvents.on('speaking', function() {
    console.log('speaking');
  });

  speechEvents.on('stopped_speaking', function() {
    console.log('stopped_speaking');
  });
});