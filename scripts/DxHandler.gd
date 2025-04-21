extends Node

var dx_text : RichTextLabel
var dx_min_timer: Timer
var dx_max_timer: Timer

func _ready():
	dx_text = $Dx
	dx_min_timer = $DxMinimum
	dx_max_timer = $DxMaximum
	
	dx_min_timer.start()
	dx_max_timer.start()

func new_prompt(new_text : String):
	# Only allow new text if the min timer has elapsed
	
	if(dx_min_timer.is_stopped()):
		if(new_text != dx_text.text):
			dx_text.text = new_text
			dx_text.visible_ratio = 0
			var tween = dx_text.create_tween()
			tween.tween_property(dx_text, "visible_ratio", 1.0, 0.5)
			# Restart timers
			dx_min_timer.start()
			dx_max_timer.start()

func _on_dx_maximum_timeout() -> void:
	# Wipe text clean
	var tween = dx_text.create_tween()
	tween.tween_property(dx_text, "visible_ratio", 0.0, 0.5)
