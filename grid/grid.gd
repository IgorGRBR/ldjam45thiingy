extends TileMap

enum CellType { EMPTY = -1, OBSTACLE, ACTOR, OBJECT }
signal world_update
var activations = 0
var current_node
var queue = []
var astar = AStar.new()

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
	
	activate()
	update_queue()
	generate_navmesh()

func _process(delta):
	emit_signal("world_update", delta)

func update_queue():
	queue = []
	for node in get_children():
		if node.type == CellType.ACTOR:
			queue.push_back(node)
	queue_next()

func queue_next():
	current_node = queue.pop_front()

func world_update(delta):
	var passed = current_node._world_update(delta)
	if passed:
		queue_next()
	if not current_node:
		update_queue()
#	for node in get_children():
#		node._world_update(delta)

func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func activate():
	activations += 1
	if activations == 1:
		connect("world_update", self, "world_update")
	
func deactivate():
	activations -= 1
	if activations == 0:
		disconnect("world_update", self, "world_update")

func find_by_tag(tag):
	for node in get_children():
		if node.tag == tag:
			return node
	return null

func connect_signals():
	for node in get_children():
		node.connect("world_update", node, "_bruh")

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	#print(cell_target_type)
	match cell_target_type:
		CellType.EMPTY:
			return update_pawn_position(pawn, cell_start, cell_target)
		CellType.OBJECT:
			var object_pawn = get_cell_pawn(cell_target)
			if pawn.collision:
				pawn.on_collision(object_pawn)
			object_pawn.queue_free()
			return update_pawn_position(pawn, cell_start, cell_target)
		CellType.ACTOR:
			var cell_pawn = get_cell_pawn(cell_target)
			if pawn.collision:
				pawn.on_collision(cell_pawn)
			if cell_pawn.collision:
				cell_pawn.on_collision(pawn)
			#print("Cell %s contains %s" % [cell_target, pawn_name])


func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, CellType.EMPTY)
	return map_to_world(cell_target) + cell_size / 2

func debug_rectangle(pos):
	var rect = ColorRect.new()
	rect.rect_position = Vector2(pos.x - 8, pos.y - 8)
	rect.rect_size = Vector2(16, 16)
	rect.color = Color(255, 0, 0)
	add_child(rect)

func debug_line(pos, h):
	var rect = ColorRect.new()
	rect.rect_position = Vector2(pos.x - 2 - 6 * int(h), pos.y - 2 - 6 * int(not h))
	rect.rect_size = Vector2(4 + 12 * int(h), 4 + 12 * int(not h))
	rect.color = Color(0, 0, 255)
	add_child(rect)

func generate_navmesh():
	astar.clear()
	var rect = get_used_rect()
	#print(rect.position.x, rect.position.y, rect.size.x, rect.size.y)
	var id = 0
	for i in range(rect.position.x, rect.size.x - 1):
		for j in range(rect.position.y, rect.size.y - 1):
			var cell_target_type = get_cellv(Vector2(i, j))
			if cell_target_type != CellType.OBSTACLE:
				astar.add_point(id, Vector3(i, j, 0))
				#debug_rectangle(Vector2(i * 32, j * 32) + cell_size/2)
				if i > 0:
					var p = astar.get_closest_point(Vector3(i-1, j, 0))
					if p:
						var pos = astar.get_point_position(p)
						var c = get_cellv(Vector2(i-1, j))
						if pos == Vector3(i-1, j, 0) and c != CellType.OBSTACLE:
							astar.connect_points(id, p, true)
							#debug_line(Vector2(i * 32, j * 32 + cell_size.y/2), true)
				if j > 0:
					var p = astar.get_closest_point(Vector3(i, j-1, 0))
					if p:
						var pos = astar.get_point_position(p)
						var c = get_cellv(Vector2(i, j-1))
						if pos == Vector3(i, j-1, 0) and c != CellType.OBSTACLE:
							astar.connect_points(id, p, true)
							#debug_line(Vector2(i * 32 + cell_size.x/2, j * 32), false)
			id += 1

func get_travel_path(a, b):
	var pa = world_to_map(a)
	var pb = world_to_map(b)
	
	var ppa = astar.get_closest_point(Vector3(pa.x, pa.y, 0))
	var ppb = astar.get_closest_point(Vector3(pb.x, pb.y, 0))
	
	return astar.get_point_path(ppa, ppb)

func get_travel_direction(a, b):
	var path = get_travel_path(a, b)
	if path.size() > 1:
		var final = path[1] - path[0]
		return Vector2(final.x, final.y)
	return Vector2()