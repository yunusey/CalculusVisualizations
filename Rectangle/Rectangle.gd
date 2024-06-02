extends Node3D

const RESOLUTION: int = 30

var size: Vector3
var color: Color
var material: Material

func _ready() -> void:
	material = $MeshInstance3D.mesh.material

func set_size(new_size: Vector3) -> void:
	size = new_size
	$MeshInstance3D.mesh.size = new_size

func set_pos(new_position: Vector3) -> void:
	position = new_position

func set_color(new_color: Color) -> void:
	if material == null: material = $MeshInstance3D.mesh.material
	color = new_color
	material.set_shader_parameter("color", new_color)

func set_alpha(new_alpha: float) -> void:
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
		var dist_from_x: float = position.x + mdt.get_vertex(i).x
		var new_x = dist_from_x * cos(angle) - position.x
		var new_z = dist_from_x * sin(angle)
		mdt.set_vertex(i, Vector3(new_x, mdt.get_vertex(i).y, new_z))
	
	for face in mdt.get_face_count():
		var normal = mdt.get_face_normal(face)
		for vertex in range(3):
			var face_vertex = mdt.get_face_vertex(face, vertex)
			mdt.set_vertex_normal(face_vertex, normal)

	mesh.clear_surfaces()
	mdt.commit_to_surface(mesh)
	$MeshInstance3D.mesh = mesh

func reset() -> void:
	## Reset the rectangle's mesh if it has been changed to ArrayMesh
	if $MeshInstance3D.mesh is ArrayMesh:
		$MeshInstance3D.mesh = BoxMesh.new()
		$MeshInstance3D.mesh.size = size
		$MeshInstance3D.mesh.material = material
