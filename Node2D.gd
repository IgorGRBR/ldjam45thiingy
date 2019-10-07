extends Node

var mydialog = ["AGA","THAT`s HOW MafIA WorKS!"]
var dialogpage = 0
onready var RichTextLabel = get_node("Polygon2D/RichTextLabel")
func _ready():
	RichTextLabel.set_bbcode(mydialog[dialogpage])
	RichTextLabel.set_visible_characters(0)
	pass


func _on_Area2D_input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton:
		if event.is_pressed():
			if RichTextLabel.get_visible_characters() > RichTextLabel.get_total_character_count():
				if dialogpage < mydialog.size()-1:
					dialogpage +=1
					RichTextLabel.set_bbcode(mydialog[dialogpage])
					RichTextLabel.set_visible_characters(0) 
			else:
				RichTextLabel.set_visible_characters(RichTextLabel.get_total_character_count())


func _on_Timer_timeout():
	RichTextLabel.set_visible_characters(RichTextLabel.get_visible_characters()+1)
	
	pass # Replace with function body.