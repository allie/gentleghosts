-- Default settings

return {
	masterVolume = 1,

	keyBindings = {
		a = {'key', 'z'},
		b = {'key', 'x'},
		x = {'key', 'c'},
		y = {'key', 'v'},
		left = {'key', 'left'},
		right = {'key', 'right'},
		up = {'key', 'up'},
		down = {'key', 'down'},
		back = {'key', 'backspace'},
		start = {'key', 'return'},
		lb = nil,
		rb = nil,
		lt = nil,
		rt = nil,
		ls = nil,
		rs = nil
	},

	gamepadBindings = {
		a = {'button', 'a'},
		b = {'button', 'b'},
		x = {'button', 'x'},
		y = {'button', 'y'},
		left = {'button', 'dpleft'},
		right = {'button', 'dpright'},
		up = {'button', 'dpup'},
		down = {'button', 'dpdown'},
		back = {'button', 'back'},
		start = {'button', 'start'},
		lb = {'button', 'leftshoulder'},
		rb = {'button', 'rightshoulder'},
		lt = {'trigger', 'triggerleft'},
		rt = {'trigger', 'triggerright'},
		ls = {'button', 'leftstick'},
		rs = {'button', 'rightstick'}
	}
}
