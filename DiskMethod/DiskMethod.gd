extends Node3D

@onready var rectangle_scene = preload("res://DiskMethod/Rectangle/Rectangle.tscn")

@export var gradient: Gradient = Gradient.new()
@export var distinction_color: Color = Color.RED
@export var ordinary_color: Color = Color.BLUE
@export var disk_rect_index: int = 0

func _ready() -> void:
	disk_rect_index = $CanvasLayer/Interface.get_disk_pos()
	update_rects()

func _on_interface_num_rect_changed() -> void:
	update_rects()

func _on_interface_shape_rotation_changed() -> void:
	var disk = get_disk()
	for rect in $Rectangles.get_children():
		if rect != disk:
			rect.set_rot($CanvasLayer/Interface.get_shape_rotation())

func _on_interface_disk_rotation_changed() -> void:
	var disk = get_disk()
	var rot = $CanvasLayer/Interface.get_disk_rotation()
	disk.set_rot(rot)

func _on_interface_shape_trans_changed() -> void:
	var disk = get_disk()
	for rect in $Rectangles.get_children():
		if rect != disk:
			var trans = $CanvasLayer/Interface.get_shape_trans()
			rect.set_alpha(1. - trans)

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
	var num_rects = $CanvasLayer/Interface.get_num_rect()
	var shape_trans = $CanvasLayer/Interface.get_shape_trans()
	var disk_trans = $CanvasLayer/Interface.get_disk_trans()
	var shape_rotation = $CanvasLayer/Interface.get_shape_rotation()
	var disk_rotation = $CanvasLayer/Interface.get_disk_rotation()
	var new_disk_index = $CanvasLayer/Interface.get_disk_pos() * (num_rects - 1)
	var old_disk = $Rectangles.get_child(disk_rect_index)
	var new_disk = $Rectangles.get_child(new_disk_index)

	old_disk.set_alpha(1. - shape_trans)
	new_disk.set_alpha(1. - disk_trans)

	old_disk.set_rot(shape_rotation)
	new_disk.set_rot(disk_rotation)

	if $CanvasLayer/Interface.get_coloring() == 1:
		new_disk.set_color(distinction_color)
		old_disk.set_color(ordinary_color)
	
	disk_rect_index = new_disk_index

func update_rects() -> void:
	var num_rects = $CanvasLayer/Interface.get_num_rect()
	var domain_min = $CanvasLayer/Interface.get_domain_min()
	var domain_max = $CanvasLayer/Interface.get_domain_max()
	var lower_function = $CanvasLayer/Interface.get_lower_function()
	var higher_function = $CanvasLayer/Interface.get_upper_function()
	var shape_rotation = $CanvasLayer/Interface.get_shape_rotation()
	var disk_rotation = $CanvasLayer/Interface.get_disk_rotation()
	var disk_trans = $CanvasLayer/Interface.get_disk_trans()
	var shape_trans = $CanvasLayer/Interface.get_shape_trans()
	var delta_x = (domain_max - domain_min) / (num_rects as float)

	for i in num_rects:
		# Evaluate function as needed.
		var x = domain_min + i * delta_x
		var lower_y = lower_function.execute([x])
		var higher_y = higher_function.execute([x])

		# Set rectangle position and color
		var rect = $Rectangles.get_child(i) if i < $Rectangles.get_child_count() else rectangle_scene.instantiate()
		rect.set_size(Vector3(delta_x, higher_y - lower_y, 0.01))
		rect.set_pos(Vector3(x + delta_x / 2, (higher_y + lower_y) / 2, 0))
		rect.set_alpha(1. - shape_trans)
		rect.set_rot(shape_rotation)
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
	disk.set_rot(disk_rotation)
	disk.set_alpha(1. - disk_trans)
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
	disk_rect_index = disk_pos * (num_rects - 1)
	return $Rectangles.get_child(disk_rect_index)
