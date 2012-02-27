var canvas;
var ctx;
var w = 0;
var h = 0;

var timer;
var updateStarted = false;
var cee;
var touches = [];
var px;
var py;

function update() {
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
    		px = touch.pageX;}
		else if (dy < dx){
   			py = touch.pageY;}
		else {
			px = touch.pageX;
			py = touch.pageY;}

		ctx.fillRect(px, py, w, h);
		ctx.fillStyle = "rgba(0, 0, 200, 1.0)";
		ctx.fill();

	}

	updateStarted = false;
}

function ol() {

	canvas = document.getElementById('canvas');
	ctx = canvas.getContext('2d');
	timer = setInterval(update, 50);

//	$.getJSON("http://localhost:9003/json/v0/devices/com.nonolithlabs.cee*/", function(data){cee = data;});

	canvas.addEventListener('touchend', function(event) {
//		ctx.clearRect(0, 0, w, h);
	});

	canvas.addEventListener('touchmove', function(event) {
		event.preventDefault();
		touches = event.touches;
	});

	canvas.addEventListener('touchstart', function(event) {
		_touch = event.touches[0];
		dx = Math.abs(px - _touch.pageX);
		dy = Math.abs(py - _touch.pageY);
		if (dx < dy){
			console.log('select x');}
		if (dy < dx){
			console.log('select y');}
	});
};
