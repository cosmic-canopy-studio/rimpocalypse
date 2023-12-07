@tool
class_name AudioPlaylistPlayer
extends AudioStreamPlayer

@export var playlist: AudioPlaylist
@export var shuffle := false
@export var current_track := 0
@export var active := true


func _ready():
	if shuffle:
		_get_next_track()

	if active:
		play_playlist(current_track)


func _process(_delta):
	if not playing and active:
		_get_next_track()
		play_playlist()


func play_playlist(track: int = current_track):
	if playing:
		return
	_set_track(track)
	print("Now playing: ", stream.resource_path)
	play(0)


func stop_playlist():
	active = false
	stop()


func _get_next_track():
	var last_track = current_track
	var playlist_size = playlist.playlist.size() - 1

	if shuffle:
		current_track = randi_range(0, playlist_size)
		if current_track == last_track:
			current_track += 1

	if current_track > playlist_size:
		current_track = 0

	_set_track(current_track)


func _set_track(track: int):
	stream = playlist.playlist[track]


func _get_configuration_warnings():
	if playlist == null:
		return ["AudioPlaylist is undefined!"]
	if playlist.playlist.size() < 1:
		return ["AudioPlaylist is empty!"]
	return []
