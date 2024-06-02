extends Node3D

@onready var rectangle_scene = preload("res://Rectangle/Rectangle.tscn")

@export var domain_min: float = 0
@export var domain_max: float = 3
@export var gradient: Gradient = Gradient.new()

func function(x: float) -> float:
	return -(x - 3) * (x + 3) / 3

func _ready() -> void:
	self.update_rects($Interface.get_num_rect())

func _on_interface_num_rect_changed(value: int) -> void:
	update_rects(value)

func _on_interface_disk_rotation_changed(value: float) -> void:
	var num_rects = $Interface.get_num_rect()
	var disk = $Rectangles.get_child(num_rects / 2)
	disk.set_rot(value)

func update_rects(value: int) -> void:
	for children in $Rectangles.get_children():
		children.queue_free()
	
	var delta_x = (domain_max - domain_min) / (value as float)

	for i in value:
		var x = domain_min + i * delta_x
		var y = function(x)
		var new_rect = rectangle_scene.instantiate()
		new_rect.set_size(Vector3(delta_x, y, 0.1))
		new_rect.set_pos(Vector3(x + delta_x / 2, y / 2, 0))
		new_rect.set_color(gradient.sample(i as float / value))
		$Rectangles.add_child(new_rect)


func _on_interface_disk_trans_changed(value: float) -> void:
	var num_rects = $Interface.get_num_rect()
	var disk = $Rectangles.get_child(num_rects / 2)
	disk.set_alpha(1. - value)
