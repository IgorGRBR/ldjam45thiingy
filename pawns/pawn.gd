extends Node2D

enum CellType { OBSTACLE, ACTOR, OBJECT }
export(CellType) var type = CellType.ACTOR
export(bool) var collision = false
