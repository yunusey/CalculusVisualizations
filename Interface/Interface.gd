extends Control

var function: Expression = null

signal num_rect_changed(value: int)
signal disk_rotation_changed(value: float)
signal disk_trans_changed(value: float)
signal coloring_changed(value: int)
signal domain_changed(new_domain_min: float, new_domain_max: float)
signal function_changed()

func _ready() -> void:
	function = get_function()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_gui"):
		visible = !visible

func _on_num_rect_value_changed(value: int) -> void:
	num_rect_changed.emit(value)

func _on_disk_rotation_value_changed(value: float) -> void:
	disk_rotation_changed.emit(value)

func _on_disk_trans_value_changed(value: float) -> void:
	disk_trans_changed.emit(value)

func _on_option_button_item_selected(index: int) -> void:
	coloring_changed.emit(index)

func _on_domain_max_value_changed(value: float) -> void:
	domain_changed.emit($ParamContainer/DomainMin.value, value)

func _on_domain_min_value_changed(value: float) -> void:
	domain_changed.emit(value, $ParamContainer/DomainMax.value)

func get_num_rect() -> int:
	return $ParamContainer/NumRect.value

func get_disk_rotation() -> float:
	return $ParamContainer/DiskRotation.value

func get_function() -> Expression:
	var func_string = $ParamContainer/FunctionEdit.text
	var new_function = Expression.new()
	var error = new_function.parse(func_string, ["x"])
	if error == OK and new_function != null:
		var value = new_function.execute([5.4], null, false)
		if value != null and value is float and !new_function.has_execute_failed():
			function = new_function

	return function

func get_coloring() -> int:
	return $ParamContainer/OptionButton.selected

func _on_function_edit_text_changed(_new_text: String) -> void:
	function_changed.emit()
