extends Node2D

enum CellType { OBSTACLE, ACTOR, OBJECT }
export(CellType) var type = CellType.ACTOR
export(bool) var collision = false
export(bool) var active = true
export(String) var tag = "none"

func _world_update(delta):
	on_world_update(delta)

func on_world_update(delta):
	pass