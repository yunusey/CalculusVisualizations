extends Node3D


func set_size(new_size: Vector3) -> void:
	$MeshInstance3D.mesh.size = new_size


func set_pos(new_pos: Vector3) -> void:
	$MeshInstance3D.position = new_pos


func set_color(new_color: Color) -> void:
	$MeshInstance3D.mesh.material.set_shader_parameter("color", new_color)


func set_alpha(new_alpha: float) -> void:
	$MeshInstance3D.mesh.material.set_shader_parameter("alpha", new_alpha)
