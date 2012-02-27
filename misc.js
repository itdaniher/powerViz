var canvas;
var ctx;
var w = 0;
var h = 0;

var timerCEE;
var timerGUI;
var updateStarted = false;
var cee;
var touches = [];
var px;
var py;

var target = 0;
var SMUMode = "DISABLED";
var targetMax;

var SMUModes = {"SIMV":2, "SVMI":1, "DISABLED":0};

function updateCEE() {
		target = Math.round(target*100)/100;
		console.log(SMUMode, target);
		_data = {mode:SMUModes[SMUMode], value:target}
		$.post("http://192.168.0.247:9003/json/v0/devices/com.nonolithlabs.cee*/a/output", JSON.stringify(_data))
}

function updateGUI() {
	if (updateStarted) return;
	updateStarted = true;

	var nw = window.innerWidth;
	var nh = window.innerHeight;

	if ((w != nw) || (h != nh)) {
		w = nw;
		h = nh;
		canvas.style.width = w+'px';
		canvas.style.height = h+'px';
		canvas.width = w;
		canvas.height = h;
	}

	if ( touches.length == 1) {
		ctx.clearRect(0, 0, w, h);
		touch = touches[0];

		if (dx < dy){
			SMUMode = "SIMV";
			targetMax = 200;  
 			px = touch.pageX;
			target = targetMax*(w-px)/w;}
			
		else if (dy < dx){
			SMUMode = "SVMI";
			targetMax = 5;
   			py = touch.pageY;
			target = targetMax*(h-py)/h;
			}
		else {
			px = touch.pageX;
			py = touch.pageY;
			}

		ctx.fillRect(px, py, w, h);
		ctx.fillStyle = "rgba(0, 0, 200, 1.0)";
		ctx.fill();

	}

	updateStarted = false;
}

function populateFromJSON(data){
	cee = data;
//	channel = cee.channels['a'];
}

function ol() {

	canvas = document.getElementById('canvas');
	ctx = canvas.getContext('2d');
	timerGUI = setInterval(updateGUI, 20);
	timerCEE = setInterval(updateCEE, 100);

//	$.getJSON("http://localhost:9003/json/v0/devices/com.nonolithlabs.cee*/", populateFromJSON);

	canvas.addEventListener('touchend', function(event) {});

	canvas.addEventListener('touchmove', function(event) {
		event.preventDefault();
		touches = event.touches;
	});

	canvas.addEventListener('touchstart', function(event) {
		var _touch = event.touches[0];
		dx = Math.abs(px - _touch.pageX);
		dy = Math.abs(py - _touch.pageY);
	});
};
