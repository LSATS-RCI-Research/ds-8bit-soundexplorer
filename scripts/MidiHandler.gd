extends Control

# Signals
signal midi_note_on()

# Objects
var midiloglabel: RichTextLabel
var dx_parent: Node
var quickstart: Node2D

# Pulse
var btn_pulse1: AnimatedSprite2D
var btn_pulse2: AnimatedSprite2D
var btn_pulse3: AnimatedSprite2D
var btn_pulse4: AnimatedSprite2D
var pot_pulse1: Sprite2D
var pot_pulse2: Sprite2D
var pot_pulse3: Sprite2D

# Wave
var btn_wave1: AnimatedSprite2D
var btn_wave2: AnimatedSprite2D
var btn_wave3: AnimatedSprite2D
var btn_wave4: AnimatedSprite2D
var pot_wave1: Sprite2D
var pot_wave2: Sprite2D

# Noise
var btn_noise1: AnimatedSprite2D
var btn_noise2: AnimatedSprite2D
var btn_noise3: AnimatedSprite2D
var pot_noise1: Sprite2D
var pot_noise2: Sprite2D
var pot_noise3: Sprite2D
var pot_noise4: Sprite2D
var pot_noise5: Sprite2D
var pot_noise6: Sprite2D

# Potentiometer math
const POT_MIN_VAL: int = 0
const POT_MAX_VAL: int = 128 # ch0 ch3 ch4 
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
	
	# Assign nodes
	midiloglabel = $MidiLogLabel
	dx_parent = $DxParent
	quickstart = $QuickStart
	
	btn_pulse1 = $Pulse/Btn1
	btn_pulse2 = $Pulse/Btn2
	btn_pulse3 = $Pulse/Btn3
	btn_pulse4 = $Pulse/Btn4
	pot_pulse1 = $Pulse/Pot1
	pot_pulse2 = $Pulse/Pot2
	pot_pulse3 = $Pulse/Pot3
	
	btn_wave1 = $Wave/Btn1
	btn_wave2 = $Wave/Btn2
	btn_wave3 = $Wave/Btn3
	btn_wave4 = $Wave/Btn4
	pot_wave1 = $Wave/Pot1
	pot_wave2 = $Wave/Pot2
	
	btn_noise1 = $Noise/Btn1
	btn_noise2 = $Noise/Btn2
	btn_noise3 = $Noise/Btn3
	pot_noise1 = $Noise/Pot1
	pot_noise2 = $Noise/Pot2
	pot_noise3 = $Noise/Pot3
	pot_noise4 = $Noise/Pot4
	pot_noise5 = $Noise/Pot5
	pot_noise6 = $Noise/Pot6
	
	midiloglabel.append_text(str(OS.get_connected_midi_inputs()))
	midiloglabel.append_text(str("\nListening to MIDI channel ", MIDI_CHANNEL_PULSE, " for PULSE"))
	midiloglabel.append_text(str("\nListening to MIDI channel ", MIDI_CHANNEL_WAVE, " for WAVE"))
	midiloglabel.append_text(str("\nListening to MIDI channel ", MIDI_CHANNEL_NOISE, " for NOISE"))

func _input(input_event):
	if input_event is InputEventMIDI:
		_print_midi_info(input_event)
		if input_event.channel == MIDI_CHANNEL_PULSE:
			if input_event.message == MIDI_MESSAGE_NOTE_ON:
				midi_note_on.emit()
				match input_event.pitch:
					MIDI_PITCH_PULSE1:
						btn_pulse1.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quickstart.turnoff()
					MIDI_PITCH_PULSE2:
						btn_pulse2.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quickstart.turnoff()
					MIDI_PITCH_PULSE3:
						btn_pulse3.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quickstart.turnoff()
					MIDI_PITCH_PULSE4:
						btn_pulse4.frame = 1
						dx_parent.new_prompt(DX_PULSE_BTN)
						quickstart.turnoff()
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
				dx_parent.new_prompt(DX_PULSE_SHP)
			elif input_event.controller_number == MIDI_CC_PULSE_ENV:
				pot_pulse2.rotation_degrees = _pot_to_degs(input_event.controller_value)
				dx_parent.new_prompt(DX_PULSE_ENV)
			elif input_event.controller_number == MIDI_CC_PULSE_SWP:
				pot_pulse3.rotation_degrees = _pot_to_degs(input_event.controller_value)
				dx_parent.new_prompt(DX_PULSE_SWP)
		elif input_event.channel == MIDI_CHANNEL_WAVE:
			if input_event.message == MIDI_MESSAGE_NOTE_ON:
				midi_note_on.emit()
				match input_event.pitch:
					MIDI_PITCH_QS:
						quickstart.turnon()
					MIDI_PITCH_WAVE1:
						btn_wave1.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quickstart.turnoff()
					MIDI_PITCH_WAVE2:
						btn_wave2.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quickstart.turnoff()
					MIDI_PITCH_WAVE3:
						btn_wave3.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quickstart.turnoff()
					MIDI_PITCH_WAVE4:
						btn_wave4.frame = 1
						dx_parent.new_prompt(DX_WAVE_BTN)
						quickstart.turnoff()
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
				dx_parent.new_prompt(DX_WAVE_SHP)
			elif input_event.controller_number == MIDI_CC_WAVE_ENV:
				pot_wave2.rotation_degrees = _pot_to_degs(input_event.controller_value)
				dx_parent.new_prompt(DX_WAVE_ENV)
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
				quickstart.turnoff()
			elif input_event.message == MIDI_MESSAGE_NOTE_OFF:
				# We lack info to do this correctly, so just affect all of them
				btn_noise1.frame = 0
				btn_noise2.frame = 0
				btn_noise3.frame = 0
		else:
			midiloglabel.append_text(str("\nIgnoring event from channel ", input_event.channel))

func _print_midi_info(midi_event):
	### Channel + Number == pot that is being used
	midiloglabel.append_text("\n--------")
	midiloglabel.append_text(str("\nChl: ", midi_event.channel))
	midiloglabel.append_text(str("  Msg: ", midi_event.message))
	midiloglabel.append_text(str("  Pit: ", midi_event.pitch))
	midiloglabel.append_text(str("\nCtrlNum: ", midi_event.controller_number))
	midiloglabel.append_text(str("  CtrlVal: ", midi_event.controller_value))

func _pot_to_degs(val: int):
	# Normalize the potentiometer's value to be a weighting between 0-1
	var val_normalized = float(val - POT_MIN_VAL) / (POT_MAX_VAL - POT_MIN_VAL)
	# Return the appropriate degree rotation value for that weighting
	return lerp(POT_MIN_DEG, POT_MAX_DEG, val_normalized)
