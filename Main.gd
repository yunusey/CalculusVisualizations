extends Node3D

@onready var rectangle_scene = preload("res://Rectangle/Rectangle.tscn")

@export var gradient: Gradient = Gradient.new()
@export var distinction_color: Color = Color.RED
@export var ordinary_color: Color = Color.BLUE

func _ready() -> void:
	self.update_rects()

func _on_interface_num_rect_changed() -> void:
	update_rects()

func _on_interface_disk_rotation_changed() -> void:
	var disk = get_disk()
	var rot = $CanvasLayer/Interface.get_disk_rotation()
	disk.set_rot(rot)

func _on_interface_disk_trans_changed() -> void:
	var disk = get_disk()
	var trans = $CanvasLayer/Interface.get_disk_trans()
	disk.set_alpha(1. - trans)

func _on_interface_coloring_changed() -> void:
	match $CanvasLayer/Interface.get_coloring():
		0: color_rects_by_gradient()
		1: color_rects_by_distinction()

func _on_interface_domain_changed() -> void:
	update_rects()

func _on_interface_function_changed() -> void:
	update_rects()

func _on_interface_disk_pos_changed() -> void:
	update_rects()

func update_rects() -> void:
	var num_rects = $CanvasLayer/Interface.get_num_rect()
	var domain_min = $CanvasLayer/Interface.get_domain_min()
	var domain_max = $CanvasLayer/Interface.get_domain_max()
	var lower_function = $CanvasLayer/Interface.get_lower_function()
	var higher_function = $CanvasLayer/Interface.get_upper_function()
	var delta_x = (domain_max - domain_min) / (num_rects as float)

	for i in num_rects:
		# Evaluate function as needed.
		var x = domain_min + i * delta_x
		var lower_y = lower_function.execute([x])
		var higher_y = higher_function.execute([x])

		# Set rectangle position and color
		var rect = $Rectangles.get_child(i) if i < $Rectangles.get_child_count() else rectangle_scene.instantiate()
		rect.reset()
		rect.set_size(Vector3(delta_x, higher_y - lower_y, 0.01))
		rect.set_pos(Vector3(x + delta_x / 2, (higher_y + lower_y) / 2, 0))
		if $CanvasLayer/Interface.get_coloring() == 0:
			rect.set_color(gradient.sample(i as float / num_rects))
		else:
			rect.set_color(ordinary_color)

		# TODO: there may be performance issues here, need to optimize
		if i >= $Rectangles.get_child_count():
			$Rectangles.add_child(rect)
	
	# Remove extra rectangles
	for i in range(num_rects, $Rectangles.get_child_count()):
		$Rectangles.get_child(i).queue_free()
	
	# Set disk properties
	var disk = get_disk()
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
	var disk = get_disk()
	for i in num_rects:
		var rect = $Rectangles.get_child(i)
		var color = distinction_color if rect == disk else ordinary_color
		rect.set_color(color)

func get_disk() -> Node3D:
	var num_rects = $CanvasLayer/Interface.get_num_rect()
	var disk_pos = $CanvasLayer/Interface.get_disk_pos()
	var disk_rect_index = disk_pos * (num_rects - 1)
	return $Rectangles.get_child(disk_rect_index)
