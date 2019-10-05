extends "res://pawns/actor.gd"

func onCollision(coll):
	print("boof")

func onReady():
	$Sprite/Camera.make_current()
	$Sprite/Camera.drag_margin_h_enabled = false
	$Sprite/Camera.drag_margin_v_enabled = false	

func update_look_direction(direction):
	pass

func move_to(target_position):
	set_process(false)
	#$AnimationPlayer.play("walk")

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	$Tween.interpolate_property($Sprite, "position", - move_direction * 32, Vector2(), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Sprite.position -= position - move_direction * 32
	position = target_position
	$Tween.start()
	
	# Stop the function execution until the animation finished
	yield($Tween, "tween_all_completed")
	set_process(true)


func bump():
	set_process(false)
	#$AnimationPlayer.play("bump")
	#yield($AnimationPlayer, "animation_finished")
	set_process(true)
