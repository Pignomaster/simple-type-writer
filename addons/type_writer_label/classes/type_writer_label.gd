## Provides a configurable "typewriter" effect on a [RichTextLabel].
@tool
class_name TypeWriterLabel extends RichTextLabel

## Emitted when the last character from the text of the last [method typewrite] has been typed.
signal typewriting_done
## Emitted when a character from the text of the last [method typewrite] has been typed.
signal typewriting_char_done(char: String)

## Current typing speed in character per second.
@export_range(0.0, 1000.0) var typing_speed: float = 40.0:
	set(value):
		typing_speed = value
		if !Engine.is_editor_hint():
			_typing_time_gap = 1.0 / typing_speed
## Optional. Plays whenever new characters are displayed on screen.
@export var typing_sound_player: AudioStreamPlayer
## Set [code]true[/code] if you want a stop after reaching a specific character.[br][br]
## [b]Do not mistake the stop for the pause[/b].[br][br]
## The [b]stop[/b] happens when reaching [member stop_characters] and has a duration defined by [member stop_duration]. After that, the typing [b]will automatically resume[/b].[br]
## The [b]pause[/b] is called by [method pause_typing], and the typing [b]will only resume after calling [method resume_typing][/b].
@export var stop_after_character: bool = false:
	set(value):
		stop_after_character = value
		notify_property_list_changed()
## Duration of the stop after reaching [member stop_characters].
@export var stop_duration: float = 1.0
## Whenever reaching [member stop_characters], the [TypeWriterLabel] will stop typing for [member stop_duration] seconds.
@export var stop_characters: Array[String] = ["."]

## Wait time starting typing (in seconds) after calling [method typewrite]
@export_range(0.0, 100.0) var wait_before_start: float = 0.0

## Wait time after finishing typing (in seconds) before sending [signal typewriting_done]
@export_range(0.0, 100.0) var wait_after_finish: float = 0.0

var _text_to_type: String = ""
var _typing: bool = false
var _typing_time_gap: float = 0.0
var _typing_timer: float = 0.0
var _stop_timer: float = 0.0
var _paused: bool = false

# Wait before & after buffers
var _wait_before_buffer: float = -999.0
var _wait_after_buffer: float = -999.0

# INSPECTOR CONFIGURATION
func _validate_property(property: Dictionary) -> void:
	var hide_list = []
	if !stop_after_character:
		hide_list.append("stop_characters")
		hide_list.append("stop_duration")

	if property.name in hide_list:
		property.usage = PROPERTY_USAGE_NO_EDITOR


# MAIN FUNCTIONS
func _ready() -> void:
	if !Engine.is_editor_hint():
		if !text.is_empty():
			typewrite(text)


func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if _typing:
			if !_paused:
				if !_text_to_type.is_empty():
					if _stop_timer <= 0:
						# Compute how much chars shall be written on the current frame.
						# More than 1 character can be written if the typing speed is higher than current framerate.
						var next_chars := ""
						while !_text_to_type.is_empty() && _typing_timer <= 0:
							var next_char = _text_to_type[0]
							_text_to_type = _text_to_type.erase(0)
							next_chars += next_char
							_typing_timer += _typing_time_gap
							# If a "stop" character is reached, do not type more characters for the current frame.
							if stop_after_character && _is_stop_character(next_char):
								_stop_timer = stop_duration
								break
						visible_characters += next_chars.length()
						# Emit signal when chars are rendered.
						typewriting_char_done.emit(next_chars)
						# Play writing sound if exists and is not playing.
						if typing_sound_player && !typing_sound_player.playing:
							typing_sound_player.play()
						_typing_timer -= delta
					_stop_timer -= delta
				else: # If typing, but has no more text to type, means the typing is done.
					_wait_after_buffer = wait_after_finish
					_typing = false
		# If a wait_before_start is configured, typing do not start until time elapsed.
		elif _wait_before_buffer > -999.0:
			if _wait_before_buffer <= 0.0:
				_wait_before_buffer = -999.0
				_paused = false
				_typing = true
			else:
				_wait_before_buffer -= delta
		# If a wait_before_start is configured, typing do not start until time elapsed.
		elif _wait_after_buffer > -999.0:
			if _wait_after_buffer <= 0.0:
				_wait_after_buffer = -999.0
				typewriting_done.emit()
			else:
				_wait_after_buffer -= delta


func _is_stop_character(char: String) -> bool:
	for stop_char in stop_characters:
		if char == stop_char:
			return true
	return false


## Returns [code]true[/code] if still has some text to type.
## It means that even if typing is paused or stopped, [method is_typing] still returns [code]true[/code].
func is_typing() -> bool:
	return _typing


## Returns [code]true[/code] if typing is paused, typically by calling [method pause_typing].
func is_paused() -> bool:
	return _paused


## Type the given text at [member typing_speed] characters per seconds.
## The given text can be BBCode.
func typewrite(text_to_type: String) -> void:
	set_deferred("_typing_time_gap", 1.0 / typing_speed)
	set_deferred("visible_characters", 0)
	set_deferred("text", text_to_type)
	
	# Remove BBCode from text to follow raw text typing.
	set_deferred("_text_to_type", _get_raw_text_from_bbcode(text_to_type))
	set_deferred("_typing_timer", 0.0)
	set_deferred("_stop_timer", 0.0)
	
	set_deferred("_wait_before_buffer", wait_before_start)
	set_deferred("_paused", true)
	set_deferred("_typing", false)


func _get_raw_text_from_bbcode(bbcode: String) -> String:
	var regex = RegEx.new()
	# Replace [img]{path}[/img] by an escape " ". It is considered as 1 character by the RichTextLabel.
	regex.compile("\\[img.*\\].*\\[\\/img\\]")
	var bbcode_without_img = regex.sub(bbcode, " ", true)
	# Then remove any other BBCode.
	regex.compile("\\[[^\\]]+\\]")
	return regex.sub(bbcode_without_img, "", true)


## Pause the current typing. Call [method resume_typing] to resume it.[br][br]
## If you want to set automatic quick pauses after reaching specific characters, you should check [member stop_after_character] option.
func pause_typing() -> void:
	set_deferred("_paused", true)


## Resume the current typing.
func resume_typing() -> void:
	set_deferred("_paused", false)


## Skip current typing and display the whole text. Will also resume typing just like calling [method resume_typing].
func skip_typing() -> void:
	set_deferred("_typing_time_gap", 0.0)
