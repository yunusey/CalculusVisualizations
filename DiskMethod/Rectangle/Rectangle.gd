extends Node3D


const RESOLUTION: int = 30


var size: Vector3
var color: Color
var material: Material = null


func set_size(new_size: Vector3) -> void:
	size = new_size


func set_pos(new_position: Vector3) -> void:
	position = new_position


func set_color(new_color: Color) -> void:
	if material == null: material = $MeshInstance3D.mesh.material
	color = new_color
	material.set_shader_parameter("color", new_color)


func set_alpha(new_alpha: float) -> void:
	if material == null: material = $MeshInstance3D.mesh.material
	material.set_shader_parameter("alpha", new_alpha)


func set_rot(new_rotation: float) -> void:
	var mesh = ArrayMesh.new()
	var box_mesh = BoxMesh.new()
	box_mesh.subdivide_depth = RESOLUTION
	box_mesh.size = size
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, box_mesh.get_mesh_arrays())
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	mdt.set_material(material)

	for i in mdt.get_vertex_count():
		var angle: float = (mdt.get_vertex(i).z + size.z / 2) / size.z * new_rotation
		# var dist_from_x: float = position.x + mdt.get_vertex(i).x
		# var new_x = dist_from_x * cos(angle) - position.x
		# var new_z = dist_from_x * sin(angle)
		var dist_from_y: float = position.y + mdt.get_vertex(i).y
		var new_z = dist_from_y * sin(angle)
		var new_y = dist_from_y * cos(angle) - position.y
		mdt.set_vertex(i, Vector3(mdt.get_vertex(i).x, new_y, new_z))
	
	for i in range(mdt.get_face_count()):
		# Thank you Godot! :D
		# Get the index in the vertex array.
		var a = mdt.get_face_vertex(i, 0)
		var b = mdt.get_face_vertex(i, 1)
		var c = mdt.get_face_vertex(i, 2)
		# Get vertex position using vertex index.
		var ap = mdt.get_vertex(a)
		var bp = mdt.get_vertex(b)
		var cp = mdt.get_vertex(c)
		# Calculate face normal.
		var n = (bp - cp).cross(ap - bp).normalized()
		# Add face normal to current vertex normal.
		# This will not result in perfect normals, but it will be close.
		mdt.set_vertex_normal(a, n + mdt.get_vertex_normal(a))
		mdt.set_vertex_normal(b, n + mdt.get_vertex_normal(b))
		mdt.set_vertex_normal(c, n + mdt.get_vertex_normal(c))

	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	$MeshInstance3D.mesh = mesh


func reset() -> void:
	## Reset the rectangle's mesh if it has been changed to ArrayMesh
	if material == null: material = $MeshInstance3D.mesh.material
	material.set_shader_parameter("color", color)
	material.set_shader_parameter("alpha", 0.5)
	if $MeshInstance3D.mesh is ArrayMesh:
		$MeshInstance3D.mesh = BoxMesh.new()
		$MeshInstance3D.mesh.size = size
		$MeshInstance3D.mesh.material = material
