extends Control

signal num_rect_changed(value: int)
signal disk_rotation_changed(value: float)
signal disk_trans_changed(value: float)

func _on_num_rect_value_changed(value: int) -> void:
	num_rect_changed.emit(value)

func _on_disk_rotation_value_changed(value: float) -> void:
	disk_rotation_changed.emit(value)

func get_num_rect() -> int:
	return $ParamContainer/NumRect.value


func _on_disk_trans_value_changed(value: float) -> void:
	disk_trans_changed.emit(value)
