extends Node

func play_sound(sound: AudioStream, location : Vector3, bus : String = "Sound", volume_db : float = 0.0, pitch : float = -1, start_position : float = 0):
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new();
	audio_player.stream = sound;
	if pitch != -1:
		audio_player.pitch_scale = pitch;
	else:
		audio_player.pitch_scale = randf_range(0.8, 1.2);
	audio_player.bus = bus;
	audio_player.volume_db = volume_db;
	audio_player.global_position = location
	
#	Make the spatialization good
	audio_player.attenuation_filter_cutoff_hz = 9000
	audio_player.attenuation_filter_db = -8
	
	add_child(audio_player);
	audio_player.play(start_position);
	await audio_player.finished;
	audio_player.queue_free();
