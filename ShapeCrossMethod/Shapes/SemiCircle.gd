extends Node3D


func set_size(new_size: Vector3) -> void:
	$MeshInstance3D.scale = new_size


func set_pos(new_pos: Vector3) -> void:
	$MeshInstance3D.position = Vector3(new_pos.x, 0, new_pos.z)


func set_color(new_color: Color) -> void:
	if $MeshInstance3D.mesh is ArrayMesh:
		$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("color", new_color)
	else:
		$MeshInstance3D.mesh.material.set_shader_parameter("color", new_color)


func set_alpha(new_alpha: float) -> void:
	if $MeshInstance3D.mesh is ArrayMesh:
		$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("alpha", new_alpha)
	else:
		$MeshInstance3D.mesh.material.set_shader_parameter("alpha", new_alpha)
