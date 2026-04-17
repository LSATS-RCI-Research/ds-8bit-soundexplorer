extends Node

@export var dx_text : RichTextLabel
@export var dx_readspeed_timer: Timer
@export var dx_obsolete_timer: Timer
@export var dx_prompt_log_size : int
var dx_prompt_log : Array[String]

func _ready():
	"""Start timers."""
	dx_readspeed_timer.start()
	dx_obsolete_timer.start()

func update_prompt_log(prompt : String) -> void:
	"""Adds the prompt to the end of the log and pops the front of the log."""
	dx_prompt_log.append(prompt)
	if dx_prompt_log.size() > dx_prompt_log_size:
		dx_prompt_log.pop_front()

func prompt_log_is_consistent() -> bool:
	"""Whether all items in the log are matching."""
	var first := dx_prompt_log[0]
	for item in dx_prompt_log:
		if item != first:
			return false
	return true

func new_prompt(prompt : String):
	"""Receives new prompts from other scripts."""
	update_prompt_log(prompt)
	# Ignore prompts until the readspeed timer has elapsed
	if(dx_readspeed_timer.is_stopped()):
		# Ignore prompts that match the current text
		if(prompt != dx_text.text):
			# Ignore prompts until entropy is low
			if(prompt_log_is_consistent()):
				show_new_prompt(prompt)

func show_new_prompt(prompt : String):
	"""Display the new prompt (with anims) and restart timers."""
	dx_text.text = prompt
	dx_text.visible_ratio = 0
	# Animate
	var tween = dx_text.create_tween()
	tween.tween_property(dx_text, "visible_ratio", 1.0, 1.0)
	# Restart timers
	dx_readspeed_timer.start()
	dx_obsolete_timer.start()

func _on_dx_obsolete_timeout() -> void:
	var tween = dx_text.create_tween()
	tween.tween_property(dx_text, "visible_ratio", 0.0, 0.5)
