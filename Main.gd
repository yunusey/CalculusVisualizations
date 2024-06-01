extends Node3D

@export var sensitivity: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# if Input.is_action_pressed("cam-move-up"):
	# 	$Camera3D.position.y += sensitivity * delta
	# 
	# if Input.is_action_pressed("cam-move-down"):
	# 	$Camera3D.position.y -= sensitivity * delta
	# 
	# if Input.is_action_pressed("cam-move-left"):
	# 	$Camera3D.position.x -= sensitivity * delta
	# 
	# if Input.is_action_pressed("cam-move-right"):
	# 	$Camera3D.position.x += sensitivity * delta
