extends AnimatedSprite2D

@export var midi_handler: Control
@export var midi_identifier: MIDIHandler.MIDITarget

func _ready():
	midi_handler.midi_event.connect(_handle_event)

func _handle_event(target : MIDIHandler.MIDITarget, event : MIDIHandler.MIDIEvent, value : int) -> void:
	print("target ", target, " event ", event, " value ", value)
	if target == midi_identifier:
		print("match")
		if event == MIDIHandler.MIDIEvent.PRESS:
			frame = 1
		elif event == MIDIHandler.MIDIEvent.RELEASE:
			frame = 0
