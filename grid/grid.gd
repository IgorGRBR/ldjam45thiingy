extends TileMap

enum CellType { EMPTY = -1, OBSTACLE, ACTOR, OBJECT}

func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)


func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)


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
				pawn.onCollision(object_pawn)
			object_pawn.queue_free()
			return update_pawn_position(pawn, cell_start, cell_target)
		CellType.ACTOR:
			var cell_pawn = get_cell_pawn(cell_target)
			if pawn.collision:
				pawn.onCollision(cell_pawn)
			if cell_pawn.collision:
				cell_pawn.onCollision(pawn)
			#print("Cell %s contains %s" % [cell_target, pawn_name])


func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, CellType.EMPTY)
	return map_to_world(cell_target) + cell_size / 2
