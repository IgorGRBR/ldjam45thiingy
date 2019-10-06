extends "pawn.gd"

onready var Grid = get_parent()
var previous_direction = Vector2()

onready var self_sprite = $Sprite

func _ready():
	update_look_direction(Vector2(1, 0))
	self.position = Grid.map_to_world(Grid.world_to_map(self.position)) + Grid.cell_size / 2
	on_ready()

func on_ready():
	pass

var ZERO_VECTOR = Vector2()
func _world_update(_delta):
	on_world_update(_delta)
	var input_direction = get_input_direction()
	if not input_direction or input_direction == ZERO_VECTOR:
		return false
	update_look_direction(input_direction)
	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		#self_sprite.position = target_position - input_direction * 32
		move_to(target_position)
	else:
		move_to(position)
		bump()
	return true


func get_input_direction():
	var result = Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)
	if previous_direction.x == 0 and previous_direction.y != 0:
		result.x = 0
	elif previous_direction.x != 0 and previous_direction.y == 0:
		result.y = 0
	elif result.x != 0 and result.y != 0:
		result.y == 0
	
	previous_direction.x = abs(result.x)
	previous_direction.y = abs(result.y)
	#print("yo")
	
	return result


func update_look_direction(direction):
	#$Pivot/Sprite.rotation = direction.angle()
	pass


func move_to(target_position):
	set_process(false)
	#$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	#var move_direction = (target_position - position).normalized()
	#$Tween.interpolate_property($Pivot, "position", - move_direction * 32, Vector2(), $AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR, Tween.EASE_IN)
	
	position = target_position
	#$Tween.start()

	# Stop the function execution until the animation finished
	#yield($AnimationPlayer, "animation_finished")
	
	set_process(true)


func bump():
	set_process(false)
	#$AnimationPlayer.play("bump")
	#yield($AnimationPlayer, "animation_finished")
	set_process(true)

