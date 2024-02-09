extends Control

@onready var system : controlSystem = get_node("/root/MainScene")

func _ready():
	$ExitButton.connect("pressed",exitRecipyBook)

var recipyListItemObject = preload("res://objects/Utility/RecipyListItem.tscn")
@onready var container = $ScrollContainer/VBoxContainer
func openRecipyBook():
	visible = true
	
	for i in system.knownRecipies.size():
		var ri = recipyListItemObject.instantiate()
		ri.setUpRecipy(system.knownRecipies[i],i)
		container.add_child(ri)

func exitRecipyBook():
	visible = false
