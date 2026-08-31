class_name MIDIHandler
extends Control

enum MIDITarget {
	NONE,
	PULSE_BTN_1,
	PULSE_BTN_2,
	PULSE_BTN_3,
	PULSE_BTN_4,
	PULSE_POT_1,
	PULSE_POT_2,
	PULSE_POT_3,
	WAVE_BTN_1,
	WAVE_BTN_2,
	WAVE_BTN_3,
	WAVE_BTN_4,
	WAVE_POT_1,
	WAVE_POT_2,
	NOISE_BTN_1,
	NOISE_BTN_2,
	NOISE_BTN_3,
	NOISE_POT_1,
	NOISE_POT_2,
	NOISE_POT_3,
	NOISE_POT_4,
	NOISE_POT_5,
	NOISE_POT_6,
}

enum MIDIEvent {
	NONE,
	PRESS,
	RELEASE,
	CHANGE,
}

# Signals
signal midi_event(target : MIDITarget, event : MIDIEvent, value : int)

# Objects
@export var midiloglabel: RichTextLabel
@export var dx_parent: Node
@export var pot_prompt_timer: Timer
@export var quick_start: Node2D

# Pulse
@export_group("Pulse Controls")
@export var btn_pulse1: AnimatedSprite2D
@export var btn_pulse2: AnimatedSprite2D
@export var btn_pulse3: AnimatedSprite2D
@export var btn_pulse4: AnimatedSprite2D
@export var pot_pulse1: Sprite2D
@export var pot_pulse2: Sprite2D
@export var pot_pulse3: Sprite2D

# Wave
@export_group("Wave Controls")
@export var btn_wave1: AnimatedSprite2D
@export var btn_wave2: AnimatedSprite2D
@export var btn_wave3: AnimatedSprite2D
@export var btn_wave4: AnimatedSprite2D
@export var pot_wave1: Sprite2D
@export var pot_wave2: Sprite2D

# Noise
@export_group("Noise Controls")
@export var btn_noise1: AnimatedSprite2D
@export var btn_noise2: AnimatedSprite2D
@export var btn_noise3: AnimatedSprite2D
@export var pot_noise1: Sprite2D
@export var pot_noise2: Sprite2D
@export var pot_noise3: Sprite2D
@export var pot_noise4: Sprite2D
@export var pot_noise5: Sprite2D
@export var pot_noise6: Sprite2D

# Potentiometer math
const POT_MIN_VAL: int = 0
const POT_MAX_VAL: int = 128
const POT_MIN_DEG: int = -135
const POT_MAX_DEG: int = 135

# MIDI Assignments
const MIDI_CHANNEL_PULSE: int = 0
const MIDI_PITCH_PULSE1: int = 62
const MIDI_PITCH_PULSE2: int = 66
const MIDI_PITCH_PULSE3: int = 69
const MIDI_PITCH_PULSE4: int = 72
const MIDI_CC_PULSE_SHP: int = 1
const MIDI_CC_PULSE_ENV: int = 2
const MIDI_CC_PULSE_SWP: int = 3

const MIDI_CHANNEL_WAVE: int = 2
const MIDI_PITCH_WAVE1: int = 62
const MIDI_PITCH_WAVE2: int = 66
const MIDI_PITCH_WAVE3: int = 69
const MIDI_PITCH_WAVE4: int = 72
const MIDI_CC_WAVE_SHP: int = 1
const MIDI_CC_WAVE_ENV: int = 2
const MIDI_PITCH_QS: int = 75

const MIDI_CHANNEL_NOISE:int = 6
const MIDI_PITCH_NOISE1: int = 70  # unused
const MIDI_PITCH_NOISE2: int = 71  # unused
const MIDI_PITCH_NOISE3: int = 72  # unused

const DX_PULSE_BTN: String = "This button makes the pulse wave instrument make a sound! Press the other green buttons for different pitches! Pulse waves are either \"on\" or \"off,\" so they look like little squares. These were often used to produce the lead melody of a song."
const DX_PULSE_ENV: String = "The \"envelope\" changes how long a sound is played and whether it starts out loud or soft, and whether it ends slowly or really fast."
const DX_PULSE_SHP: String = "This knob changes the duty cycle (or the amount of time the signal is considered \"on\") of the waveform and determines the timbre of the sound. A pulse wave is a very simple waveform that is either \"on\" or \"off.\""
const DX_PULSE_SWP: String = "The pitch sweep will change the pitch of the note while it is being played. So, it may start out at one pitch but then slide fast or slowly to another. Turn this knob all the way to the left if you don’t want it to sweep."

const DX_WAVE_BTN: String = "This button makes the wave instrument make a sound! Press the other blue buttons for different pitches! This instrument uses a programmable waveform that allows a composer to create sounds that a square or triangle wave cannot produce. Tip: move the sound shape knob, above, to switch between the 16 different sounds."
const DX_WAVE_ENV: String = "The \"envelope\" changes how long a sound is played and whether it starts out loud or soft, and whether it ends slowly or really fast."
const DX_WAVE_SHP: String = "The wave instrument is like a tiny little sampler that plays back the sound wave shape that was programmed into it. Moving this knob changes which of the 16 different sounds it will play! Some of the shapes look like triangles, some look round, and others are messy and noisy."

const DX_NOISE_BTN: String = "This is a pseudo-random waveform making different types of atonal noise! These sounds were most often used for percussion instruments or sound effects like explosions."


func _ready():
	# Receive MIDI Inputs
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

	midiloglabel.append_text(str(OS.get_connected_midi_inputs()))
	midiloglabel.append_text(str("\nListening to MIDI channel ", MIDI_CHANNEL_PULSE, " for PULSE"))
	midiloglabel.append_text(str("\nListening to MIDI channel ", MIDI_CHANNEL_WAVE, " for WAVE"))
	midiloglabel.append_text(str("\nListening to MIDI channel ", MIDI_CHANNEL_NOISE, " for NOISE"))

func _input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)
		var target : MIDITarget
		var event : MIDIEvent
		var value : int
		var is_noise : bool = false
		
		# Determine MIDI target
		match input_event.channel:
			MIDI_CHANNEL_PULSE:
				match input_event.pitch:
					MIDI_PITCH_PULSE1:
						target = MIDITarget.PULSE_BTN_1
					MIDI_PITCH_PULSE2:
						target = MIDITarget.PULSE_BTN_2
					MIDI_PITCH_PULSE3:
						target = MIDITarget.PULSE_BTN_3
					MIDI_PITCH_PULSE4:
						target = MIDITarget.PULSE_BTN_4
				match input_event.controller_number:
					MIDI_CC_PULSE_SHP:
						target = MIDITarget.PULSE_POT_1
					MIDI_CC_PULSE_ENV:
						target = MIDITarget.PULSE_POT_2
					MIDI_CC_PULSE_SWP:
						target = MIDITarget.PULSE_POT_3
			MIDI_CHANNEL_WAVE:
				match input_event.pitch:
					MIDI_PITCH_WAVE1:
						target = MIDITarget.WAVE_BTN_1
					MIDI_PITCH_WAVE2:
						target = MIDITarget.WAVE_BTN_2
					MIDI_PITCH_WAVE3:
						target = MIDITarget.WAVE_BTN_3
					MIDI_PITCH_WAVE4:
						target = MIDITarget.WAVE_BTN_4
				match input_event.controller_number:
					MIDI_CC_WAVE_SHP:
						target = MIDITarget.WAVE_POT_1
					MIDI_CC_WAVE_ENV:
						target = MIDITarget.WAVE_POT_2
			MIDI_CHANNEL_NOISE:
				# We currently lack the info needed to do this correctly
				target = MIDITarget.NOISE_BTN_1
				is_noise = true

		# Determine MIDI Event
		match input_event.message:
			MIDI_MESSAGE_NOTE_ON:
				event = MIDIEvent.PRESS
				value = input_event.velocity
			MIDI_MESSAGE_NOTE_OFF:
				event = MIDIEvent.RELEASE
				value = 0
		if input_event.controller_number != 0:
			event = MIDIEvent.CHANGE
			value = input_event.controller_value
		
		# Emit signal
		if target != MIDITarget.NONE and event != MIDIEvent.NONE:
			if is_noise:
				# We currently lack the info needed to do this correctly
				midi_event.emit(MIDITarget.NOISE_BTN_1, event, value)
				midi_event.emit(MIDITarget.NOISE_BTN_2, event, value)
				midi_event.emit(MIDITarget.NOISE_BTN_3, event, value)
				midi_event.emit(MIDITarget.NOISE_POT_1, event, value)
				midi_event.emit(MIDITarget.NOISE_POT_2, event, value)
				midi_event.emit(MIDITarget.NOISE_POT_3, event, value)
				midi_event.emit(MIDITarget.NOISE_POT_4, event, value)
				midi_event.emit(MIDITarget.NOISE_POT_5, event, value)
				midi_event.emit(MIDITarget.NOISE_POT_6, event, value)
			else:
				midi_event.emit(target, event, value)
	return
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)
		if input_event.channel == MIDI_CHANNEL_PULSE:
			if input_event.message == MIDI_MESSAGE_NOTE_ON:
				match input_event.pitch:
					MIDI_PITCH_PULSE1:
						btn_pulse1.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quick_start.turnoff()
					MIDI_PITCH_PULSE2:
						btn_pulse2.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quick_start.turnoff()
					MIDI_PITCH_PULSE3:
						btn_pulse3.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quick_start.turnoff()
					MIDI_PITCH_PULSE4:
						btn_pulse4.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quick_start.turnoff()
			elif input_event.message == MIDI_MESSAGE_NOTE_OFF:
				match input_event.pitch:
					MIDI_PITCH_PULSE1:
						btn_pulse1.frame = 0
					MIDI_PITCH_PULSE2:
						btn_pulse2.frame = 0
					MIDI_PITCH_PULSE3:
						btn_pulse3.frame = 0
					MIDI_PITCH_PULSE4:
						btn_pulse4.frame = 0
			elif input_event.controller_number == MIDI_CC_PULSE_SHP:
				pot_pulse1.rotation_degrees = _pot_to_degs(input_event.controller_value)
				sendPotPrompt(DX_PULSE_SHP)
			elif input_event.controller_number == MIDI_CC_PULSE_ENV:
				pot_pulse2.rotation_degrees = _pot_to_degs(input_event.controller_value)
				sendPotPrompt(DX_PULSE_ENV)
			elif input_event.controller_number == MIDI_CC_PULSE_SWP:
				pot_pulse3.rotation_degrees = _pot_to_degs(input_event.controller_value)
				sendPotPrompt(DX_PULSE_SWP)
		elif input_event.channel == MIDI_CHANNEL_WAVE:
			if input_event.message == MIDI_MESSAGE_NOTE_ON:
				#midi_note_on.emit()
				match input_event.pitch:
					MIDI_PITCH_QS:
						quick_start.turnon()
					MIDI_PITCH_WAVE1:
						btn_wave1.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quick_start.turnoff()
					MIDI_PITCH_WAVE2:
						btn_wave2.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quick_start.turnoff()
					MIDI_PITCH_WAVE3:
						btn_wave3.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quick_start.turnoff()
					MIDI_PITCH_WAVE4:
						btn_wave4.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quick_start.turnoff()
			elif input_event.message == MIDI_MESSAGE_NOTE_OFF:
				match input_event.pitch:
					MIDI_PITCH_WAVE1:
						btn_wave1.frame = 0
					MIDI_PITCH_WAVE2:
						btn_wave2.frame = 0
					MIDI_PITCH_WAVE3:
						btn_wave3.frame = 0
					MIDI_PITCH_WAVE4:
						btn_wave4.frame = 0
			elif input_event.controller_number == MIDI_CC_WAVE_SHP:
				pot_wave1.rotation_degrees = _pot_to_degs(input_event.controller_value)
				sendPotPrompt(DX_WAVE_SHP)
			elif input_event.controller_number == MIDI_CC_WAVE_ENV:
				pot_wave2.rotation_degrees = _pot_to_degs(input_event.controller_value)
				sendPotPrompt(DX_WAVE_ENV)
		elif input_event.channel == MIDI_CHANNEL_NOISE:
			if input_event.message == MIDI_MESSAGE_NOTE_ON:
				# We lack info to do this correctly, so just affect all of them
				btn_noise1.frame = 1
				btn_noise2.frame = 1
				btn_noise3.frame = 1
				dx_parent.new_prompt(DX_NOISE_BTN)
				pot_noise2.rotation_degrees = _pot_to_degs(input_event.controller_value)
				pot_noise4.rotation_degrees = _pot_to_degs(input_event.controller_value)
				pot_noise6.rotation_degrees = _pot_to_degs(input_event.controller_value)
				quick_start.turnoff()
			elif input_event.message == MIDI_MESSAGE_NOTE_OFF:
				# We lack info to do this correctly, so just affect all of them
				btn_noise1.frame = 0
				btn_noise2.frame = 0
				btn_noise3.frame = 0
		else:
			midiloglabel.append_text(str("\nIgnoring event from channel ", input_event.channel))

func sendPotPrompt(prompt : String) -> void:
	"""Throttles the rate at which Pot prompts are sent."""
	if pot_prompt_timer.is_stopped():
		dx_parent.new_prompt(prompt)
		pot_prompt_timer.start()

func _print_midi_info(event):
	### Channel + Number == pot that is being used
	midiloglabel.append_text("\n--------")
	midiloglabel.append_text(str("\nChl: ", event.channel))
	midiloglabel.append_text(str("  Msg: ", event.message))
	midiloglabel.append_text(str("  Pit: ", event.pitch))
	midiloglabel.append_text(str("\nCtrlNum: ", event.controller_number))
	midiloglabel.append_text(str("  CtrlVal: ", event.controller_value))

func _pot_to_degs(val: int):
	# Normalize the potentiometer's value to be a weighting between 0-1
	var val_normalized = float(val - POT_MIN_VAL) / (POT_MAX_VAL - POT_MIN_VAL)
	# Return the appropriate degree rotation value for that weighting
	return lerp(POT_MIN_DEG, POT_MAX_DEG, val_normalized)
