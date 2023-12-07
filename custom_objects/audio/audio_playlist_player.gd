class_name AudioPlaylistPlayer
extends AudioStreamPlayer

@export var playlist: AudioPlaylist
@export var shuffle := false
@export var current_track_index := 0
@export var active := true:
	set = _set_active


func _ready():
	if shuffle:
		_get_next_track()

	if active:
		play_playlist(current_track_index)


func _process(_delta):
	if not playing and active:
		_get_next_track()
		play_playlist()


func play_playlist(track_index: int = current_track_index):
	if playing:
		return
	_set_stream(track_index)
	print("Now playing: ", stream.resource_path)
	play(0)


func stop_playlist():
	active = false


func _get_next_track():
	var last_track = current_track_index
	var playlist_size = playlist.playlist.size() - 1

	if shuffle:
		current_track_index = randi_range(0, playlist_size)
		if current_track_index == last_track:
			current_track_index += 1

	if current_track_index > playlist_size:
		current_track_index = 0

	_set_stream(current_track_index)


func _set_active(new_state: bool):
	active = new_state
	if active == true:
		_get_next_track()
		play_playlist()
	else:
		stop()
		stream = null


func _set_stream(track: int):
	stream = playlist.playlist[track]


func _get_configuration_warnings():
	if playlist == null:
		return ["AudioPlaylist is undefined!"]
	if playlist.playlist.size() < 1:
		return ["AudioPlaylist is empty!"]
	return []
