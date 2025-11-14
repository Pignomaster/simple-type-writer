extends Control

@onready var type_writer_label: TypeWriterLabel = $TypeWriterLabel
@onready var audio_stream_player: AudioStreamPlayer = $SignalBasedAudioSteamPlayer

var play_audio_on_signal: bool = false


func _on_type_writer_label_typewriting_done() -> void:
	type_writer_label.typewrite("This text starts right after the previous one.")


func _on_type_writer_label_typewriting_char_done(character: String) -> void:
	if !play_audio_on_signal or character == " ":
		return

	if !audio_stream_player.playing:
		audio_stream_player.play()


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("test_interrupt") && type_writer_label.is_typing():
		type_writer_label.typewrite("You just skipped the previous text.")


func _on_check_button_toggled(toggled_on: bool) -> void:
	play_audio_on_signal = toggled_on
	if toggled_on:
		type_writer_label.typing_sound_player = null
	else:
		type_writer_label.typing_sound_player = %AudioStreamPlayer
