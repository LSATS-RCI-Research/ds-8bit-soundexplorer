extends Node2D

var min_timer : Timer
var max_timer : Timer

func _ready():
	min_timer = $QSMinimum
	max_timer = $QSMaximum

func turnon():
	if(self.visible == false):
		self.visible = true
		min_timer.start()
		max_timer.start()
	else:
		self.visible = false

func turnoff():
	if(min_timer.is_stopped()):
		self.visible = false

func _on_qs_maximum_timeout() -> void:
	self.visible = false
