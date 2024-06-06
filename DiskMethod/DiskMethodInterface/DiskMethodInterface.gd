extends Control

var lower_function: Expression = null
var upper_function: Expression = null

signal num_rect_changed()
signal shape_rotation_changed()
signal disk_rotation_changed()
signal shape_trans_changed()
signal disk_trans_changed()
signal disk_pos_changed()
signal coloring_changed()
signal domain_changed()
signal function_changed()

func _ready() -> void:
	$ParamContainer/OptionButton.select(0)
	lower_function = get_lower_function()
	upper_function = get_upper_function()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_gui"):
		visible = !visible

func _on_num_rect_value_changed(_value: int) -> void:
	num_rect_changed.emit()

func _on_disk_rotation_value_changed(_value: float) -> void:
	disk_rotation_changed.emit()

func _on_shape_rotation_value_changed(_value: float) -> void:
	shape_rotation_changed.emit()

func _on_disk_trans_value_changed(_value: float) -> void:
	disk_trans_changed.emit()

func _on_shape_trans_value_changed(_value: float) -> void:
	shape_trans_changed.emit()

func _on_option_button_item_selected(_value: int) -> void:
	coloring_changed.emit()

func _on_domain_max_value_changed(_value: float) -> void:
	domain_changed.emit()

func _on_domain_min_value_changed(_value: float) -> void:
	domain_changed.emit()

func _on_function_edit_text_changed(_new_text: String) -> void:
	function_changed.emit()

func _on_disk_pos_value_changed(_value: float) -> void:
	disk_pos_changed.emit()

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func get_num_rect() -> int:
	return $ParamContainer/NumRect.value

func get_shape_rotation() -> float:
	return $ParamContainer/ShapeRotation.value

func get_disk_rotation() -> float:
	return $ParamContainer/DiskRotation.value

func get_shape_trans() -> float:
	return $ParamContainer/ShapeTrans.value

func get_disk_trans() -> float:
	return $ParamContainer/DiskTrans.value

func get_lower_function() -> Expression:
	var new_function = get_function_from_string($ParamContainer/LowerFunction.text)
	if new_function != null:
		lower_function = new_function
	return lower_function

func get_upper_function() -> Expression:
	var new_function = get_function_from_string($ParamContainer/UpperFunction.text)
	if new_function != null:
		upper_function = new_function
	return upper_function

func get_function_from_string(func_string: String) -> Expression:
	var new_function = Expression.new()
	var error = new_function.parse(func_string, ["x"])
	if error == OK and new_function != null:
		var value = new_function.execute([5.4], null, false)
		if !new_function.has_execute_failed() and value != null and (value is float or value is int):
			return new_function
	return null

func get_coloring() -> int:
	return $ParamContainer/OptionButton.selected

func get_domain_min() -> float:
	return $ParamContainer/DomainMin.value

func get_domain_max() -> float:
	return $ParamContainer/DomainMax.value

func get_disk_pos() -> float:
	return $ParamContainer/DiskPos.value

