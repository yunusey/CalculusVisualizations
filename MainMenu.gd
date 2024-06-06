extends Control

func _on_disk_method_button_pressed() -> void:
	get_tree().change_scene_to_file("res://DiskMethod/DiskMethod.tscn")

func _on_shape_cross_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ShapeCrossMethod/ShapeCrossMethod.tscn")

func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://AboutPage/AboutPage.tscn")
