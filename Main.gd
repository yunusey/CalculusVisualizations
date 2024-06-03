extends Node3D

@onready var rectangle_scene = preload("res://Rectangle/Rectangle.tscn")

@export var domain_min: float = 0
@export var domain_max: float = 3
@export var gradient: Gradient = Gradient.new()
@export var distinction_color: Color = Color.RED
@export var ordinary_color: Color = Color.BLUE

func _ready() -> void:
	self.update_rects($CanvasLayer/Interface.get_num_rect())

func _on_interface_num_rect_changed(value: int) -> void:
	update_rects(value)

func _on_interface_disk_rotation_changed(value: float) -> void:
	var num_rects = $CanvasLayer/Interface.get_num_rect()
	var disk = $Rectangles.get_child(num_rects / 2)
	disk.set_rot(value)

func _on_interface_disk_trans_changed(value: float) -> void:
	var num_rects = $CanvasLayer/Interface.get_num_rect()
	var disk = $Rectangles.get_child(num_rects / 2)
	disk.set_alpha(1. - value)

func _on_interface_coloring_changed(value: int) -> void:
	match value:
		0: color_rects_by_gradient()
		1: color_rects_by_distinction()

func _on_interface_domain_changed(new_domain_min: float, new_domain_max: float) -> void:
	self.domain_min = new_domain_min
	self.domain_max = new_domain_max
	update_rects($CanvasLayer/Interface.get_num_rect())

func update_rects(value: int) -> void:
	var delta_x = (domain_max - domain_min) / (value as float)
	var function: Expression = $CanvasLayer/Interface.get_function()
	for i in value:
		var x = domain_min + i * delta_x
		var y = function.execute([x])
		var rect = $Rectangles.get_child(i) if i < $Rectangles.get_child_count() else rectangle_scene.instantiate()

		rect.reset()
		rect.set_size(Vector3(delta_x, y, 0.01))
		rect.set_pos(Vector3(x + delta_x / 2, y / 2, 0))
		if $CanvasLayer/Interface.get_coloring() == 0:
			rect.set_color(gradient.sample(i as float / value))
		else:
			rect.set_color(ordinary_color)

		if i >= $Rectangles.get_child_count():
			$Rectangles.add_child(rect)
	
	for i in range(value, $Rectangles.get_child_count()):
		$Rectangles.get_child(i).queue_free()
	
	@warning_ignore("integer_division")
	var disk_rect_index = value / 2
	var disk = $Rectangles.get_child(disk_rect_index)
	var disk_rotation = $CanvasLayer/Interface.get_disk_rotation()
	disk.set_rot(disk_rotation)

	disk.set_alpha(1. - $CanvasLayer/Interface.get_disk_trans())
	if $CanvasLayer/Interface.get_coloring() == 1:
		disk.set_color(distinction_color)
	
func color_rects_by_gradient() -> void:
	var num_rects = $Rectangles.get_child_count()
	for i in num_rects:
		$Rectangles.get_child(i).set_color(
			gradient.sample(i as float / num_rects)
		)

func color_rects_by_distinction() -> void:
	var num_rects = $Rectangles.get_child_count()

	@warning_ignore("integer_division")
	var disk_rect_index = num_rects / 2

	for i in num_rects:
		if i == disk_rect_index:
			$Rectangles.get_child(i).set_color(distinction_color)
		else:
			$Rectangles.get_child(i).set_color(ordinary_color)

func _on_interface_function_changed() -> void:
	update_rects($CanvasLayer/Interface.get_num_rect())
