extends Node2D

enum CellType { OBSTACLE, ACTOR, OBJECT }
export(CellType) var type = CellType.ACTOR
export(bool) var collision = false
export(bool) var active = true

func _world_update(delta):
	pass