extends Control

@export var availableRecipies : Array[recipy]

@onready var container = $PanelContainer/MarginContainer/GridContainer
func _ready():
	updateAnvilMenu()
	$ExitButton.connect("pressed",get_parent().hideAnvilMenu)

func updateAnvilMenu():
	var item = container.get_child(0)
	item.get_node("image").texture = availableRecipies[0].recipyCustomImage
	item.get_node("Button").connect("pressed",func(): chooseItem(0))
	
	for i in availableRecipies.size():
		if i != 0:
			var newItem = item.duplicate()
			newItem.get_node("image").texture = availableRecipies[i].recipyCustomImage
			newItem.get_node("Button").connect("pressed",func(): chooseItem(i))
			container.add_child(newItem)

func chooseItem(index):
	get_parent().setUpRecipy(availableRecipies[index])
	get_parent().hideAnvilMenu()
