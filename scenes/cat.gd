extends AnimatedSprite2D

@export var midi_handler: Node

func _ready():
	midi_handler.midi_note_on.connect(_on_note_on)

func _on_note_on():
	self.frame = randi() % self.sprite_frames.get_frame_count('default')
	if not TweenFX.is_playing(self, TweenFX.Animations.SQUASH):
		TweenFX.squash(self, 0.1, 0.2)
