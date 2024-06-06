extends Control


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(meta)


func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")
