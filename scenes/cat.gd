extends AnimatedSprite2D

@export var midi_handler: Node

func _ready():
	midi_handler.midi_event.connect(_handle_event)

func _handle_event(target : MIDIHandler.MIDITarget, event : MIDIHandler.MIDIEvent, value : int):
	if event == MIDIHandler.MIDIEvent.PRESS:
		self.frame = randi() % self.sprite_frames.get_frame_count('default')
		if not TweenFX.is_playing(self, TweenFX.Animations.SQUASH):
			TweenFX.squash(self, 0.1, 0.2)
