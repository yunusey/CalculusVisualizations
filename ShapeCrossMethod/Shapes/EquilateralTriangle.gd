extends Node3D


func set_size(new_size: Vector3) -> void:
	# In triangle, this process is a bit different.
	$MeshInstance3D.mesh.size = Vector3(new_size.z, new_size.y * sqrt(3) / 2, new_size.x)


func set_pos(new_pos: Vector3) -> void:
	# In triangle, this process is a bit different.
	$MeshInstance3D.position = Vector3(new_pos.x, new_pos.y * sqrt(3) / 2, new_pos.z)


func set_color(new_color: Color) -> void:
	$MeshInstance3D.mesh.material.set_shader_parameter("color", new_color)


func set_alpha(new_alpha: float) -> void:
	$MeshInstance3D.mesh.material.set_shader_parameter("alpha", new_alpha)
