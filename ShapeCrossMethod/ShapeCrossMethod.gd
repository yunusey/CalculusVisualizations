extends Node3D

@onready var square_scene = preload("res://ShapeCrossMethod/Shapes/Square.tscn")
@onready var triangle_scene = preload("res://ShapeCrossMethod/Shapes/EquilateralTriangle.tscn")

@export var gradient: Gradient = Gradient.new()
@export var distinction_color: Color = Color.RED
@export var ordinary_color: Color = Color.BLUE

func _ready() -> void:
	update_shapes()

func _on_shape_type_changed() -> void:
	for shape in $Shapes.get_children():
		shape.queue_free()
		await shape.tree_exited

	update_shapes()

func _on_num_shapes_changed() -> void:
	update_shapes()

func _on_shape_trans_changed() -> void:
	var trans = $CanvasLayer/ShapeCrossMethodInterface.get_shape_trans()
	var disk = get_disk()
	for shape in $Shapes.get_children():
		if shape != disk:
			shape.set_alpha(1. - trans)

func _on_disk_trans_changed() -> void:
	var trans = $CanvasLayer/ShapeCrossMethodInterface.get_disk_trans()
	var disk = get_disk()
	disk.set_alpha(1. - trans)

func _on_disk_pos_changed() -> void:
	update_shapes()

func _on_coloring_changed() -> void:
	match $CanvasLayer/ShapeCrossMethodInterface.get_coloring():
		0: color_shapes_by_gradient()
		1: color_shapes_by_distinction()

func _on_domain_changed() -> void:
	update_shapes()

func _on_function_changed() -> void:
	update_shapes()

func update_shapes() -> void:
	var shape_scene = get_shape_scene()
	var num_shapes = $CanvasLayer/ShapeCrossMethodInterface.get_num_shapes()
	var shape_trans = $CanvasLayer/ShapeCrossMethodInterface.get_shape_trans()
	var disk_trans = $CanvasLayer/ShapeCrossMethodInterface.get_disk_trans()
	var coloring = $CanvasLayer/ShapeCrossMethodInterface.get_coloring()
	var function = $CanvasLayer/ShapeCrossMethodInterface.get_function()
	var domain_min = $CanvasLayer/ShapeCrossMethodInterface.get_domain_min()
	var domain_max = $CanvasLayer/ShapeCrossMethodInterface.get_domain_max()
	var delta_x = (domain_max - domain_min) / (num_shapes as float)
	
	for i in num_shapes:
		var x = domain_min + i * delta_x
		var y = function.execute([x])
		var shape = $Shapes.get_child(i) if i < $Shapes.get_child_count() else shape_scene.instantiate()

		# Set shape properties
		shape.set_size(Vector3(delta_x, y, y))
		shape.set_pos(Vector3(x + delta_x / 2, y / 2, 0))
		shape.set_alpha(1. - shape_trans)
		if coloring == 0:
			shape.set_color(gradient.sample(i as float / num_shapes))
		else:
			shape.set_color(ordinary_color)

		# Add shape if needed
		if i >= $Shapes.get_child_count():
			$Shapes.add_child(shape)
	
	# Remove extra shapes
	for i in range(num_shapes, $Shapes.get_child_count()):
		$Shapes.get_child(i).queue_free()
	
	# Set disk properties
	var disk = get_disk()
	disk.set_alpha(1. - disk_trans)
	if coloring == 1:
		disk.set_color(distinction_color)

func get_disk() -> Node3D:
	var num_shapes = $CanvasLayer/ShapeCrossMethodInterface.get_num_shapes()
	var disk_pos = $CanvasLayer/ShapeCrossMethodInterface.get_disk_pos()
	var disk_shape_index = disk_pos * (num_shapes - 1)
	return $Shapes.get_child(disk_shape_index)

func color_shapes_by_gradient() -> void:
	var num_shapes = $Shapes.get_child_count()
	for i in num_shapes:
		$Shapes.get_child(i).set_color(
			gradient.sample(i as float / num_shapes)
		)

func color_shapes_by_distinction() -> void:
	var num_shapes = $Shapes.get_child_count()
	var disk = get_disk()
	for i in num_shapes:
		var shape = $Shapes.get_child(i)
		var color = distinction_color if shape == disk else ordinary_color
		shape.set_color(color)

func get_shape_scene() -> PackedScene:
	match $CanvasLayer/ShapeCrossMethodInterface.get_shape_type():
		0: return square_scene
		1: return triangle_scene
		_: return square_scene
