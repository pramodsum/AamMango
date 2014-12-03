(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
// These will be initialized later
var recognizer, recorder, callbackManager, audioContext, outputContainer;
// Only when both recorder and recognizer do we have a ready application
var recorderReady = recognizerReady = false;
var selectedWord;


// A convenience function to post a message to the recognizer and associate
// a callback to its response
function postRecognizerJob(message, callback) {
  var msg = message || {};
  if (callbackManager) msg.callbackId = callbackManager.add(callback);
  if (recognizer) recognizer.postMessage(msg);
};


// This function initializes an instance of the recorder
// it posts a message right away and calls onReady when it
// is ready so that onmessage can be properly set
function spawnWorker(workerURL, onReady) {
    recognizer = new Worker(workerURL);
    recognizer.onmessage = function(event) {
      onReady(recognizer);
    };
    recognizer.postMessage('');
};


// To display the hypothesis sent by the recognizer
function updateHyp(hyp) {
  if (outputContainer) outputContainer.innerHTML = hyp;
};


// This updates the UI when the app might get ready
// Only when both recorder and recognizer are ready do we enable the buttons
function updateUI() {
  var selectTag = document.getElementById('words');

  var gid = document.getElementById('grammars').value;
  var wid = document.getElementById('words').value;
  selectedWord = grammars[gid].g.transitions[wid];
  startBtn.disabled = stopBtn.disabled = false;
};


// This is just a logging window where we display the status
function updateStatus(newStatus) {
  console.log("STATUS: " + newStatus);
};


// A not-so-great recording indicator
function displayRecording(display) {
  if (display) document.getElementById('recording-indicator').innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
  else document.getElementById('recording-indicator').innerHTML = "";
};


// Callback function once the user authorises access to the microphone
// in it, we instanciate the recorder
function startUserMedia(stream) {
  var input = audioContext.createMediaStreamSource(stream);
  // Firefox hack https://support.mozilla.org/en-US/questions/984179
  window.firefox_audio_hack = input; 
  var audioRecorderConfig = {errorCallback: function(x) { if(x != "silent") updateStatus("Error from recorder: " + x); }};
  recorder = new AudioRecorder(input, audioRecorderConfig);
  // If a recognizer is ready, we pass it to the recorder
  if (recognizer) recorder.consumers = [recognizer];
  recorderReady = true;
  updateUI();
  updateStatus("Audio recorder ready");
};


// This starts recording. We first need to get the id of the grammar to use
var startRecording = function() {
  var id = document.getElementById('grammars').value;
  if (recorder && recorder.start(id)) displayRecording(true);
};


// Stops recording
var stopRecording = function() {
  recorder && recorder.stop();
  displayRecording(false);
};


// We get the words defined in the selected grammar set below and 
// fill in the input select tag
var updateWordList = function() {
  var id = document.getElementById('grammars').value;
  var selectTag = document.getElementById('words');
  selectTag.length=0
  for(var i = 0; i < grammars[id].g.transitions.length; i++) {
      var newElt = document.createElement('option');
      newElt.value=i;
      newElt.innerHTML = grammars[id].g.transitions[i].text;
      selectTag.appendChild(newElt);
  }
}


// Called once the recognizer is ready
// We then add the grammars to the input select tag and update the UI
var recognizerReady = function() {
     updateGrammars();
     recognizerReady = true;
     updateUI();
     updateStatus("Recognizer ready");
     updateWordList();
};


// We get the grammars defined below and fill in the input select tag
var updateGrammars = function() {
  var selectTag = document.getElementById('grammars');
  for (var i = grammarIds.length - 1; i >= 0; i--) {
      var newElt = document.createElement('option');
      newElt.value=grammarIds[i].id;
      newElt.innerHTML = grammarIds[i].title;
      selectTag.appendChild(newElt);
  }
};


// This adds a grammar from the grammars array
// We add them one by one and call it again as
// a callback.
// Once we are done adding all grammars, we can call
// recognizerReady()
var feedGrammar = function(g, index, id) {
  if (id && (grammarIds.length > 0)) grammarIds[0].id = id.id;
  if (index < g.length) {
    grammarIds.unshift({title: g[index].title})
postRecognizerJob({command: 'addGrammar', data: g[index].g},
                       function(id) {feedGrammar(grammars, index + 1, {id:id});});
  } else {
    recognizerReady();
  }
};


// This adds words to the recognizer. When it calls back, we add grammars
var feedWords = function(words) {
     postRecognizerJob({command: 'addWords', data: words},
                  function() {feedGrammar(grammars, 0);});
};


// This initializes the recognizer. When it calls back, we add words
var initRecognizer = function() {
    // You can pass parameters to the recognizer, such as : {command: 'initialize', data: [["-hmm", "my_model"], ["-fwdflat", "no"]]}
    postRecognizerJob({command: 'initialize'},
                      function() {
                                  if (recorder) recorder.consumers = [recognizer];
                                  feedWords(wordList);});
};


// When the page is loaded, we spawn a new recognizer worker and call getUserMedia to
// request access to the microphone
window.onload = function() {
  outputContainer = document.getElementById("output");
  wordsContainer = document.getElementById("words");
  updateStatus("Initializing web audio and speech recognizer, waiting for approval to access the microphone");
  callbackManager = new CallbackManager();
  spawnWorker("js/recognizer.js", function(worker) {
      // This is the onmessage function, once the worker is fully loaded
      worker.onmessage = function(e) {
          // This is the case when we have a callback id to be called
          if (e.data.hasOwnProperty('id')) {
            var clb = callbackManager.get(e.data['id']);
            var data = {};
            if ( e.data.hasOwnProperty('data')) data = e.data.data;
            if(clb) clb(data);
          }
          // This is a case when the recognizer has a new hypothesis
          if (e.data.hasOwnProperty('hyp')) {
            var newHyp = output = e.data.hyp;
            if(newHyp == "") return;
            stopRecording();

            var gid = document.getElementById('grammars').value;
            var wid = document.getElementById('words').value;
            selectedWord = grammars[gid].g.transitions[wid];
            console.log(grammars[gid].g.transitions[wid]);

            if(newHyp == selectedWord.word) {
              output = "YAY! You said " + selectedWord.text + " correctly!";
            } else {
              output = "NO! You said " + newHyp + " instead of " + selectedWord.text;
            }
            updateHyp(output);
          }
          // This is the case when we have an error
          if (e.data.hasOwnProperty('status') && (e.data.status == "error")) {
            updateStatus("Error in " + e.data.command + " with code " + e.data.code);
          }
      };
      // Once the worker is fully loaded, we can call the initialize function
      initRecognizer();
  });
  // The following is to initialize Web Audio
  try {
    window.AudioContext = window.AudioContext || window.webkitAudioContext;
    // navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
    window.URL = window.URL || window.webkitURL;
    audioContext = new AudioContext();
  } catch (e) {
    updateStatus("Error initializing Web Audio browser");
  }
  if (navigator.getUserMedia) navigator.getUserMedia({audio: true}, startUserMedia, function(e) {
                                  updateStatus("No live audio input in this browser");
                              });
  else updateStatus("No web audio support in this browser");


// Wiring JavaScript to the UI
var startBtn = document.getElementById('startBtn');
var stopBtn = document.getElementById('stopBtn');
startBtn.disabled = true;
stopBtn.disabled = true;
startBtn.onclick = startRecording;
stopBtn.onclick = stopRecording;
};

 // This is the list of words that need to be added to the recognizer
 // This follows the CMU dictionary format
var wordList = [["bonda", "b o nd. aa"], ["manchurian", "m a nch uu r i y a n"], ["pakora", "p a k o r. aa"], ["papad", "p aa p a r."], ["samosa", "s a m o s aa"], ["vada", "v a d. aa "], ["lassi", "l as s ii"], ["batura", "b:h a t uu r aa"], ["kulcha", "k ul a ch aa"], ["naan", "n aa n"], ["paratha", "p a r aa nt:h aa"], ["poori", "p uu r ii"], ["roti", "r o t ii"], ["bagara", "b a g aa r aa"], ["bartha", "b:h a r a th aa"], ["chettinand", "ch et ti n a n:d"], ["gosht", "g o shth"], ["makhani", "m a k:h a n ii"], ["navratan", "n a v a r a th a n"], ["pasanda", "p a s a nd aa"], ["tadka", "th a r. a k aa"], ["tikka", "t ik k aa "], ["vindaloo", "w in: d aa l uu"], ["gulabjamun", "g uu l aaa b j aa m uu n"], ["halwa", "h a l a w aa"], ["kheer", "k:h ii r"], ["payasam", "p aa y a s a m"], ["kulfi", "k ul ph ii"], ["rasmalai", "r a s a m a l a ii"], ["ek", "e k"], ["do", "d o"], ["theen", "th ii n"], ["chaar", "ch aa r"], ["paanch", "p aa n:ch"], ["che", "ch h"], ["saath", "s aa th"], ["aat", "aa t:h"], ["nau", "n au"], ["dus", "d a s"], ["badam", "b aa d aam"], ["murg", "m u r:g"], ["kaaju", "k aa j uu"], ["biryani", "b i r a y aa n ii"], ["bisibelebaath", "b i s i b e l e b aa th"], ["pulav", "p u l aa w"], ["upma", "u p a m aa"], ["vangibaath", "v a n:g ii b aa th"], ["venpongal", "v e n:p o n:g a l"], ["achaar", "a ch aa r"], ["dahi", "d a h ii"], ["raita", "r aa y a th aa"], ["adai", "a d. ae"], ["avial", "a v ii y a l"], ["dosa", "d. o s aa"], ["uthappam", "uth th ap p a m "], ["aloo", "aa l uu"], ["baingan", "b ae n:g a n"], ["bhindi", "b:h i n:d. ii"], ["channa", "ch a n aa"], ["gajar", "g aa j a r"], ["gobi", "g o b ii"], ["matar", "m a t a r"], ["palak", "p aa l a k"], ["saag", "s aa g"], ["chole", "c:h o l e"], ["dal", "d aa l"], ["idli", "I d. a l ii"], ["jalfrezi", "j a l ph r:e z ii "], ["rasam", "r a s a m"], ["sambar", "s a m:b aa r"], ["kadai", "k a r. aa ii"], ["keema", "k ii m aa"], ["lachcha", "l ach ch: aa"], ["shahi", "sh aa h ii"], ["kurma", "k oo rm aa"], ["malai", "m a l aa ii"], ["kofta", "k o phth aa"], ["dopyaz", "d o py aa z"], ["pudina", "p u d ii n aa"], ["rava", "r a v aa"], ["tandoor", "t a n:d oo r"], ["seekh", "s ii k:h"], ["boti", "b o t ii "], ["tangri", "t a n:g r. ii"]];

var gram_appetizer = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "bonda", text: "Bonda"},
  {from: 0, to: 0, logp: -5, word: "manchurian", text: "Manchurian"},
  {from: 0, to: 0, logp: -5, word: "pakora", text: "Pakora"},
  {from: 0, to: 0, logp: -5, word: "papad", text: "Papad"},
  {from: 0, to: 0, logp: -5, word: "samosa", text: "Samosa"},
  {from: 0, to: 0, logp: -5, word: "vada", text: "Vada"}
]};

var gram_beverages = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "lassi", text: "Lassi"}
]};

var gram_breads = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "batura", text: "Batura"},
  {from: 0, to: 0, logp: -5, word: "kulcha", text: "Kulcha"},
  {from: 0, to: 0, logp: -5, word: "naan", text: "Naan"},
  {from: 0, to: 0, logp: -5, word: "paratha", text: "Paratha"},
  {from: 0, to: 0, logp: -5, word: "poori", text: "Poori"},
  {from: 0, to: 0, logp: -5, word: "roti", text: "Roti"}
]};

var gram_curries = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "bagara", text: "Bagara"},
  {from: 0, to: 0, logp: -5, word: "bartha", text: "Bartha"},
  {from: 0, to: 0, logp: -5, word: "chettinand", text: "Chettinand"},
  {from: 0, to: 0, logp: -5, word: "gosht", text: "Gosht"},
  {from: 0, to: 0, logp: -5, word: "makhani", text: "Makhani"},
  {from: 0, to: 0, logp: -5, word: "navratan", text: "Navratan"},
  {from: 0, to: 0, logp: -5, word: "pasanda", text: "Pasanda"},
  {from: 0, to: 0, logp: -5, word: "tadka", text: "Tadka"},
  {from: 0, to: 0, logp: -5, word: "tikka", text: "Tikka"},
  {from: 0, to: 0, logp: -5, word: "vindaloo", text: "Vindaloo"}
]};

var gram_desserts = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "gulabjamun", text: "Gulab Jamun"},
  {from: 0, to: 0, logp: -5, word: "halwa", text: "Halwa"},
  {from: 0, to: 0, logp: -5, word: "kheer", text: "Kheer"},
  {from: 0, to: 0, logp: -5, word: "payasam", text: "Payasam"},
  {from: 0, to: 0, logp: -5, word: "kulfi", text: "Kulfi"},
  {from: 0, to: 0, logp: -5, word: "rasmalai", text: "Rasmalai"}
]};

var gram_none = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "kadai", text: "Kadai"},
  {from: 0, to: 0, logp: -5, word: "keema", text: "Keema"},
  {from: 0, to: 0, logp: -5, word: "lachcha", text: "Lachcha"},
  {from: 0, to: 0, logp: -5, word: "shahi", text: "Shahi"},
  {from: 0, to: 0, logp: -5, word: "kurma", text: "Kurma"},
  {from: 0, to: 0, logp: -5, word: "malai", text: "Malai"},
  {from: 0, to: 0, logp: -5, word: "kofta", text: "Kofta"},
  {from: 0, to: 0, logp: -5, word: "dopyaz", text: "DoPyaz"},
  {from: 0, to: 0, logp: -5, word: "pudina", text: "Pudina"},
  {from: 0, to: 0, logp: -5, word: "rava", text: "Rava"},
  {from: 0, to: 0, logp: -5, word: "tandoor", text: "Tandoor"},
  {from: 0, to: 0, logp: -5, word: "seekh", text: "Seekh"},
  {from: 0, to: 0, logp: -5, word: "boti", text: "Boti"},
  {from: 0, to: 0, logp: -5, word: "tangri", text: "Tangri"}
]};

var gram_number = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "ek", text: "Ek"},
  {from: 0, to: 0, logp: -5, word: "do", text: "Do"},
  {from: 0, to: 0, logp: -5, word: "theen", text: "Theen"},
  {from: 0, to: 0, logp: -5, word: "chaar", text: "Chaar"},
  {from: 0, to: 0, logp: -5, word: "paanch", text: "Paanch"},
  {from: 0, to: 0, logp: -5, word: "che", text: "Che"},
  {from: 0, to: 0, logp: -5, word: "saath", text: "Saath"},
  {from: 0, to: 0, logp: -5, word: "aat", text: "Aat"},
  {from: 0, to: 0, logp: -5, word: "nau", text: "Nau"},
  {from: 0, to: 0, logp: -5, word: "dus", text: "Dus"}
]};

var gram_proteins = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "badam", text: "Badam"},
  {from: 0, to: 0, logp: -5, word: "murg", text: "Murg"},
  {from: 0, to: 0, logp: -5, word: "kaaju", text: "Kaaju"}
]};

var gram_rice = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "biryani", text: "Biryani"},
  {from: 0, to: 0, logp: -5, word: "bisibelebaath", text: "Bisibele Baath"},
  {from: 0, to: 0, logp: -5, word: "pulav", text: "Pulav"},
  {from: 0, to: 0, logp: -5, word: "upma", text: "Upma"},
  {from: 0, to: 0, logp: -5, word: "vangibaath", text: "Vangibaath"},
  {from: 0, to: 0, logp: -5, word: "venpongal", text: "Venpongal"}
]};

var gram_sides = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "achaar", text: "Achaar"},
  {from: 0, to: 0, logp: -5, word: "dahi", text: "Dahi"},
  {from: 0, to: 0, logp: -5, word: "raita", text: "Raita"}
]};

var gram_south = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "adai", text: "Adai"},
  {from: 0, to: 0, logp: -5, word: "avial", text: "Avial"},
  {from: 0, to: 0, logp: -5, word: "dosa", text: "Dosa"},
  {from: 0, to: 0, logp: -5, word: "uthappam", text: "Uthappam"}
]};

var gram_vegetables = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "aloo", text: "Aloo"},
  {from: 0, to: 0, logp: -5, word: "baingan", text: "Baingan"},
  {from: 0, to: 0, logp: -5, word: "bhindi", text: "Bhindi"},
  {from: 0, to: 0, logp: -5, word: "channa", text: "Channa"},
  {from: 0, to: 0, logp: -5, word: "gajar", text: "Gajar"},
  {from: 0, to: 0, logp: -5, word: "gobi", text: "Gobi"},
  {from: 0, to: 0, logp: -5, word: "matar", text: "Matar"},
  {from: 0, to: 0, logp: -5, word: "palak", text: "Palak"},
  {from: 0, to: 0, logp: -5, word: "saag", text: "Saag"}
]};

var gram_vegetarian = {
  numStates: 1, start: 0, end: 0, transitions: [
  {from: 0, to: 0, logp: -5, word: "chole", text: "Chole"},
  {from: 0, to: 0, logp: -5, word: "dal", text: "Dal"},
  {from: 0, to: 0, logp: -5, word: "idli", text: "Idli"},
  {from: 0, to: 0, logp: -5, word: "jalfrezi", text: "Jal Frezi"},
  {from: 0, to: 0, logp: -5, word: "rasam", text: "Rasam"},
  {from: 0, to: 0, logp: -5, word: "sambar", text: "Sambar"}
]};

var grammars = [
  {title: "Appetizers", g: gram_appetizer}, 
  {title: "Beverages", g: gram_beverages}, 
  {title: "Breads", g: gram_breads}, 
  {title: "Curries", g: gram_curries}, 
  {title: "Desserts", g: gram_desserts}, 
  {title: "Numbers", g: gram_number}, 
  {title: "Proteins", g: gram_proteins}, 
  {title: "Rice Dishes", g: gram_rice}, 
  {title: "Sides", g: gram_sides}, 
  {title: "South Indian Dishes", g: gram_south}, 
  {title: "Vegetables", g: gram_vegetables}, 
  {title: "Vegetarian", g: gram_vegetarian}, 
  {title: "No Category", g: gram_none}
];
var grammarIds = [];

(function () {

  function drawLine(canvas, data, color) {
    var drawContext = canvas.getContext('2d');
    drawContext.moveTo(0,canvas.height);
    drawContext.beginPath();
    drawContext.strokeStyle = color;
    for (var i = 0; i < data.length; i++) {
      var value = -data[i];
      var percent = value / 100;
      var height = canvas.height * percent;
      var vOffset = height; //canvas.height - height - 5;
      var hOffset = i * canvas.width / 100.0;
      drawContext.lineTo(hOffset, vOffset);
    }
    drawContext.stroke();
  }
  function draw() {
    var canvas = document.querySelector('canvas');
    if (!canvas) return;
    var drawContext = canvas.getContext('2d');
    drawContext.clearRect (0, 0, canvas.width, canvas.height);

    drawLine(canvas, streamVolumes, '#00BFA0');
    drawLine(canvas, referenceVolumes, '#6562EF');
    window.requestAnimationFrame(draw);
  }
  window.requestAnimationFrame(draw);
})();

var streamVolumes = [];
var referenceVolumes = [];
for (var i = 0; i < 100; i++) {
  streamVolumes.push(-100);
  referenceVolumes.push(-50);
}

var hark = require('hark')

var getUserMedia = require('getusermedia')

getUserMedia(function(err, stream) {
  if (err) throw err

  var options = {};
  var speechEvents = hark(stream, options);

  speechEvents.on('speaking', function() {
    console.log('speaking');
    startRecording();
  });

  speechEvents.on('volume_change', function(volume, threshold) {
    // console.log(volume, threshold)
    if(volume > threshold) {
      document.getElementById('recording-indicator').innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;";
    } else {
      document.getElementById('recording-indicator').innerHTML = "";
    }
    streamVolumes.push(volume);
    streamVolumes.shift();
  });

  speechEvents.on('stopped_speaking', function() {
    console.log('stopped_speaking');
    stopRecording();
  });
});
},{"getusermedia":2,"hark":3}],2:[function(require,module,exports){
// getUserMedia helper by @HenrikJoreteg
var func = (window.navigator.getUserMedia ||
            window.navigator.webkitGetUserMedia ||
            window.navigator.mozGetUserMedia ||
            window.navigator.msGetUserMedia);


module.exports = function (constraints, cb) {
    var options;
    var haveOpts = arguments.length === 2;
    var defaultOpts = {video: true, audio: true};
    var error;
    var denied = 'PermissionDeniedError';
    var notSatified = 'ConstraintNotSatisfiedError';

    // make constraints optional
    if (!haveOpts) {
        cb = constraints;
        constraints = defaultOpts;
    }

    // treat lack of browser support like an error
    if (!func) {
        // throw proper error per spec
        error = new Error('MediaStreamError');
        error.name = 'NotSupportedError';
        return cb(error);
    }

    if (localStorage && localStorage.useFirefoxFakeDevice === "true") {
        constraints.fake = true;
    }

    func.call(window.navigator, constraints, function (stream) {
        cb(null, stream);
    }, function (err) {
        var error;
        // coerce into an error object since FF gives us a string
        // there are only two valid names according to the spec
        // we coerce all non-denied to "constraint not satisfied".
        if (typeof err === 'string') {
            error = new Error('MediaStreamError');
            if (err === denied) {
                error.name = denied;
            } else {
                error.name = notSatified;
            }
        } else {
            // if we get an error object make sure '.name' property is set
            // according to spec: http://dev.w3.org/2011/webrtc/editor/getusermedia.html#navigatorusermediaerror-and-navigatorusermediaerrorcallback
            error = err;
            if (!error.name) {
                // this is likely chrome which
                // sets a property called "ERROR_DENIED" on the error object
                // if so we make sure to set a name
                if (error[denied]) {
                    err.name = denied;
                } else {
                    err.name = notSatified;
                }
            }
        }

        cb(error);
    });
};

},{}],3:[function(require,module,exports){
var WildEmitter = require('wildemitter');

function getMaxVolume (analyser, fftBins) {
  var maxVolume = -Infinity;
  analyser.getFloatFrequencyData(fftBins);

  for(var i=4, ii=fftBins.length; i < ii; i++) {
    if (fftBins[i] > maxVolume && fftBins[i] < 0) {
      maxVolume = fftBins[i];
    }
  };

  return maxVolume;
}


var audioContextType = window.webkitAudioContext || window.AudioContext;
// use a single audio context due to hardware limits
var audioContext = null;
module.exports = function(stream, options) {
  var harker = new WildEmitter();


  // make it not break in non-supported browsers
  if (!audioContextType) return harker;

  //Config
  var options = options || {},
      smoothing = (options.smoothing || 0.1),
      interval = (options.interval || 50),
      threshold = options.threshold,
      play = options.play,
      history = options.history || 10,
      running = true;

  //Setup Audio Context
  if (!audioContext) {
    audioContext = new audioContextType();
  }
  var sourceNode, fftBins, analyser;

  analyser = audioContext.createAnalyser();
  analyser.fftSize = 512;
  analyser.smoothingTimeConstant = smoothing;
  fftBins = new Float32Array(analyser.fftSize);

  if (stream.jquery) stream = stream[0];
  if (stream instanceof HTMLAudioElement || stream instanceof HTMLVideoElement) {
    //Audio Tag
    sourceNode = audioContext.createMediaElementSource(stream);
    if (typeof play === 'undefined') play = true;
    threshold = threshold || -50;
  } else {
    //WebRTC Stream
    sourceNode = audioContext.createMediaStreamSource(stream);
    threshold = threshold || -50;
  }

  sourceNode.connect(analyser);
  if (play) analyser.connect(audioContext.destination);

  harker.speaking = false;

  harker.setThreshold = function(t) {
    threshold = t;
  };

  harker.setInterval = function(i) {
    interval = i;
  };
  
  harker.stop = function() {
    running = false;
    harker.emit('volume_change', -100, threshold);
    if (harker.speaking) {
      harker.speaking = false;
      harker.emit('stopped_speaking');
    }
  };
  harker.speakingHistory = [];
  for (var i = 0; i < history; i++) {
      harker.speakingHistory.push(0);
  }

  // Poll the analyser node to determine if speaking
  // and emit events if changed
  var looper = function() {
    setTimeout(function() {
    
      //check if stop has been called
      if(!running) {
        return;
      }
      
      var currentVolume = getMaxVolume(analyser, fftBins);

      harker.emit('volume_change', currentVolume, threshold);

      var history = 0;
      if (currentVolume > threshold && !harker.speaking) {
        // trigger quickly, short history
        for (var i = harker.speakingHistory.length - 3; i < harker.speakingHistory.length; i++) {
          history += harker.speakingHistory[i];
        }
        if (history >= 2) {
          harker.speaking = true;
          harker.emit('speaking');
        }
      } else if (currentVolume < threshold && harker.speaking) {
        for (var i = 0; i < harker.speakingHistory.length; i++) {
          history += harker.speakingHistory[i];
        }
        if (history == 0) {
          harker.speaking = false;
          harker.emit('stopped_speaking');
        }
      }
      harker.speakingHistory.shift();
      harker.speakingHistory.push(0 + (currentVolume > threshold));

      looper();
    }, interval);
  };
  looper();


  return harker;
}

},{"wildemitter":4}],4:[function(require,module,exports){
/*
WildEmitter.js is a slim little event emitter by @henrikjoreteg largely based 
on @visionmedia's Emitter from UI Kit.

Why? I wanted it standalone.

I also wanted support for wildcard emitters like this:

emitter.on('*', function (eventName, other, event, payloads) {
    
});

emitter.on('somenamespace*', function (eventName, payloads) {
    
});

Please note that callbacks triggered by wildcard registered events also get 
the event name as the first argument.
*/
module.exports = WildEmitter;

function WildEmitter() {
    this.callbacks = {};
}

// Listen on the given `event` with `fn`. Store a group name if present.
WildEmitter.prototype.on = function (event, groupName, fn) {
    var hasGroup = (arguments.length === 3),
        group = hasGroup ? arguments[1] : undefined,
        func = hasGroup ? arguments[2] : arguments[1];
    func._groupName = group;
    (this.callbacks[event] = this.callbacks[event] || []).push(func);
    return this;
};

// Adds an `event` listener that will be invoked a single
// time then automatically removed.
WildEmitter.prototype.once = function (event, groupName, fn) {
    var self = this,
        hasGroup = (arguments.length === 3),
        group = hasGroup ? arguments[1] : undefined,
        func = hasGroup ? arguments[2] : arguments[1];
    function on() {
        self.off(event, on);
        func.apply(this, arguments);
    }
    this.on(event, group, on);
    return this;
};

// Unbinds an entire group
WildEmitter.prototype.releaseGroup = function (groupName) {
    var item, i, len, handlers;
    for (item in this.callbacks) {
        handlers = this.callbacks[item];
        for (i = 0, len = handlers.length; i < len; i++) {
            if (handlers[i]._groupName === groupName) {
                //console.log('removing');
                // remove it and shorten the array we're looping through
                handlers.splice(i, 1);
                i--;
                len--;
            }
        }
    }
    return this;
};

// Remove the given callback for `event` or all
// registered callbacks.
WildEmitter.prototype.off = function (event, fn) {
    var callbacks = this.callbacks[event],
        i;

    if (!callbacks) return this;

    // remove all handlers
    if (arguments.length === 1) {
        delete this.callbacks[event];
        return this;
    }

    // remove specific handler
    i = callbacks.indexOf(fn);
    callbacks.splice(i, 1);
    return this;
};

/// Emit `event` with the given args.
// also calls any `*` handlers
WildEmitter.prototype.emit = function (event) {
    var args = [].slice.call(arguments, 1),
        callbacks = this.callbacks[event],
        specialCallbacks = this.getWildcardCallbacks(event),
        i,
        len,
        item,
        listeners;

    if (callbacks) {
        listeners = callbacks.slice();
        for (i = 0, len = listeners.length; i < len; ++i) {
            if (listeners[i]) {
                listeners[i].apply(this, args);
            } else {
                break;
            }
        }
    }

    if (specialCallbacks) {
        len = specialCallbacks.length;
        listeners = specialCallbacks.slice();
        for (i = 0, len = listeners.length; i < len; ++i) {
            if (listeners[i]) {
                listeners[i].apply(this, [event].concat(args));
            } else {
                break;
            }
        }
    }

    return this;
};

// Helper for for finding special wildcard event handlers that match the event
WildEmitter.prototype.getWildcardCallbacks = function (eventName) {
    var item,
        split,
        result = [];

    for (item in this.callbacks) {
        split = item.split('*');
        if (item === '*' || (split.length === 2 && eventName.slice(0, split[0].length) === split[0])) {
            result = result.concat(this.callbacks[item]);
        }
    }
    return result;
};

},{}]},{},[1]);
