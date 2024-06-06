extends Control

var function: Expression = null

signal shape_type_changed()
signal num_shapes_changed()
signal shape_trans_changed()
signal disk_trans_changed()
signal disk_pos_changed()
signal coloring_changed()
signal function_changed()
signal domain_changed()

func _ready() -> void:
	$ParamContainer/ShapeButton.select(0)
	function = get_function()

func _on_shape_button_item_selected(_index: int) -> void:
	shape_type_changed.emit()

func _on_num_shapes_changed(_value: float) -> void:
	num_shapes_changed.emit()

func _on_shape_trans_changed(_value: float) -> void:
	shape_trans_changed.emit()

func _on_disk_trans_changed(_value: float) -> void:
	disk_trans_changed.emit()

func _on_disk_pos_changed(_value: float) -> void:
	disk_pos_changed.emit()

func _on_coloring_button_item_selected(_index: int) -> void:
	coloring_changed.emit()

func _on_function_text_changed(_new_text: String) -> void:
	function_changed.emit()

func _on_domain_max_value_changed(_value: float) -> void:
	domain_changed.emit()

func _on_domain_min_value_changed(_value: float) -> void:
	domain_changed.emit()

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func get_shape_type() -> int:
	return $ParamContainer/ShapeButton.selected

func get_num_shapes() -> int:
	return $ParamContainer/NumShapes.value

func get_shape_trans() -> float:
	return $ParamContainer/ShapeTrans.value

func get_disk_trans() -> float:
	return $ParamContainer/DiskTrans.value

func get_disk_pos() -> float:
	return $ParamContainer/DiskPos.value

func get_coloring() -> int:
	return $ParamContainer/ColoringButton.selected

func get_function_from_string(func_string: String) -> Expression:
	var new_function = Expression.new()
	var error = new_function.parse(func_string, ["x"])
	if error == OK and new_function != null:
		var value = new_function.execute([5.4], null, false)
		if !new_function.has_execute_failed() and value != null and (value is float or value is int):
			return new_function
	return null

func get_function() -> Expression:
	var new_function = get_function_from_string($ParamContainer/Function.text)
	if new_function != null:
		function = new_function
	return function

func get_domain_min() -> float:
	return $ParamContainer/DomainMin.value

func get_domain_max() -> float:
	return $ParamContainer/DomainMax.value
