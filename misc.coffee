SMUmode = "DISABLED"
touches = []
px = py = dx = dy = 0

updateCEE = ->
	SMUModes =
		DISABLED: 0
		SVMI: 1
		SIMV: 2
	target = Math.round ( @target*100 )
	target = target/100
	console.log SMUModes[@SMUMode], target
	_data =
		mode: SMUModes[@SMUMode]
		value: target
	$.post "http://192.168.0.247:9003/json/v0/devices/com.nonolithlabs.cee*/a/output", JSON.stringify _data

updateGUI = ->
	nw = window.innerWidth
	nh = window.innerHeight
	if w isnt nw or h isnt nh
		w = nw
		h = nh
		@canvas.style.width = w+'px'
		@canvas.style.height = h+'px'
		@canvas.width = w
		@canvas.height = h
	if @touches.length is 1
		@ctx.clearRect 0, 0, w, h
		touch = @touches[0]
		if @dx < @dy
			@SMUMode = "SIMV"
			targetMax = 200
			@px = touch.pageX
			@target = targetMax*(w-px)/w
		else if @dy < @dx
			@SMUMode = "SVMI"
			targetMax = 5
			@py = touch.pageY
			@target = targetMax*(h-py)/h
		else
			@SMUMode = "disabled"
			@target = 0
	@ctx.fillRect px, py, w, h
	@ctx.fillStyle = "rgba(0, 0, 200, 1.0)"
	@ctx.fill()

populateFromJSON = (data) -> cee = data

ol = ->
	window.canvas = $("#canvas")[0]
	window.ctx = canvas.getContext '2d'
	timerGUI = setInterval updateGUI, 20
	timerCEE = setInterval updateCEE, 100
#	$.getJSON("http://localhost:9003/json/v0/devices/com.nonolithlabs.cee*/", populateFromJSON)
#	canvas.addEventListener 'touchend', (event) => pass
	@canvas.addEventListener 'touchmove', (event) =>
		event.preventDefault()
		@touches = event.touches
	@canvas.addEventListener 'touchstart', (event) =>
		_touch = event.touches[0]
		@dx = Math.abs @px - _touch.pageX
		@dy = Math.abs @py - _touch.pageY
