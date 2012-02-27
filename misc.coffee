SMUMode = "DISABLED"
SMUModes =
	DISABLED: 0
	SVMI: 1
	SIMV: 2
touches = []
w = h = px = py = dx = dy = 0
v = i = target = 0

serverIP = "192.168.0.247"

drawing = false

updateCEE = ->
	target = Math.round ( target*100 )
	target = target/100
	_data =
		mode: SMUModes[SMUMode]
		value: target
	$.post "http://" + serverIP + ":9003/json/v0/devices/com.nonolithlabs.cee*/a/output", JSON.stringify _data
	$.get "http://" + serverIP + ":9003/json/v0/devices/com.nonolithlabs.cee*/a/input", {count:1}, (data) ->
		data = data.split('\n')[1]
		data = (parseFloat item for item in data.split(','))
		v = data[0]
		i = data[1]

updateGUI = ->
	if not drawing
		drawing = true
		nw = innerWidth
		nh = innerHeight
		if w isnt nw or h isnt nh
			w = nw
			h = nh
			window.canvas.style.width = w+'px'
			window.canvas.style.height = h+'px'
			window.canvas.width = w
			window.canvas.height = h
		if touches.length is 1
			window.ctx.clearRect 0, 0, w, h
			touch = touches[0]
			if dx < dy
				SMUMode = "SIMV"
				px = touch.pageX
				target = 200*(w-px)/w
				py = h - v/5*h
			else if dy < dx
				SMUMode = "SVMI"
				py = touch.pageY
				target = 5*(h-py)/h
				px = w - i/200*w
			else
				SMUMode = "DISABLED"
				target = 0
		window.ctx.fillStyle = "rgba(0, 0, 200, 0.3)"
		window.ctx.fillRect px, py, w, h
		window.ctx.fillStyle = "rgba(0, 0, 0, 1.0)"
		window.ctx.font = "bold 32px sans-serif"
		window.ctx.fillText (Math.round(i*v/10)/100).toString() + "watts", w*11/24, h*11/24
		window.ctx.fillText (Math.round(v*10000/i)/100).toString() + "ohms", w*11/24, h*13/24
		window.ctx.fill()
		drawing = false


ol = ->
	window.canvas = $("#canvas")[0]
	window.ctx = window.canvas.getContext '2d'
	updateGUI()
	timerCEE = setInterval updateCEE, 15
#	$.getJSON "http://localhost:9003/json/v0/devices/com.nonolithlabs.cee*/", (data) ->
#		cee = data
#	window.canvas.addEventListener 'touchend', (event) =>
	window.canvas.addEventListener 'touchmove', (event) =>
		event.preventDefault()
		touches = event.touches
		updateGUI()
	window.canvas.addEventListener 'touchstart', (event) =>
		_touch = event.touches[0]
		dx = Math.abs px - _touch.pageX
		dy = Math.abs py - _touch.pageY
