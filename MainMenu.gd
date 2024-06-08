extends Control


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		print(DisplayServer.window_get_mode())
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_disk_method_button_pressed() -> void:
	get_tree().change_scene_to_file("res://DiskMethod/DiskMethod.tscn")


func _on_shape_cross_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ShapeCrossMethod/ShapeCrossMethod.tscn")


func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://AboutPage/AboutPage.tscn")
