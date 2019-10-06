extends Control


func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/Exit.grab_focus()
	
func _physics_proccess(delta):
	if $MarginContainer/VBoxContainer/HBoxContainer/Exit.is_hovered() == true:
			$MarginContainer/VBoxContainer/HBoxContainer/Exit.grab_focus()
	if $MarginContainer/VBoxContainer/HBoxContainer/NewGame.is_hovered() == true:
			$MarginContainer/HBoxContainer/VBoxContainer/NewGame.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/LoadGame.is_hovered() == true:
		$MarginContainer/VBoxContainer/HBoxContainer2/LoadGame.grab_focus()

func _on_NewGame_pressed():
	get_tree().change_scene("Gaaame.tscn")

func _on_Exit_pressed():
	get_tree().quit()