extends TileMap

enum CellType { EMPTY = -1, OBSTACLE, ACTOR, OBJECT }
signal world_update
var activations = 0
var current_node
var queue = []

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
	activate()
	update_queue()

func _process(delta):
	emit_signal("world_update", delta)

func update_queue():
	queue = get_children()
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

func connect_signals():
	for node in get_children():
		node.connect("world_update", node, "_bruh")

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	print(cell_target_type)
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
