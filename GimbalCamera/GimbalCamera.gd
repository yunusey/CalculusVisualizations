extends Node3D

## Rotation speed for camera
@export var rotation_speed = PI / 2

func handle_rotation(delta):
	var y_rotation = Input.get_axis("cam-move-left", "cam-move-right")
	var x_rotation = Input.get_axis("cam-move-up", "cam-move-down")
	rotate_object_local(Vector3.UP, y_rotation * rotation_speed * delta)
	$InnerAxis.rotate_object_local(Vector3.RIGHT, x_rotation * rotation_speed * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		self.scale -= Vector3.ONE * 0.01
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		self.scale += Vector3.ONE * 0.01
	
	self.scale = clamp(self.scale, Vector3.ONE * 0.1, Vector3.ONE * 5)

func _process(delta):
	handle_rotation(delta)
