extends "pawn.gd"

onready var Grid = get_parent()

func _ready():
	self.position = Grid.map_to_world(Grid.world_to_map(self.position)) + Grid.cell_size / 2
	onReady()

func onReady():
	pass
