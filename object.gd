extends "pawn.gd"

onready var Grid = get_parent()

func _ready():
	update_look_direction(Vector2(1, 0))
	onReady()

func onReady():
	pass
