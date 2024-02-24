extends Control

@onready var system : controlSystem = get_node("/root/MainScene")


func _ready():
	$Book/ExitButton.connect("pressed",exitRecipyBookAnimation)

var recipyListItemObject = preload("res://objects/Utility/RecipyListItem.tscn")
@onready var container = $ScrollContainer/VBoxContainer
func openRecipyBook():
	visible = true
	
	if system.knownRecipies.size() > 0:
		container.visible = true
		$Book/LabelEmpty.visible = false
	
	$AnimationPlayer.play("open")

func updateRecipyList():
	for ch in container.get_children():
		ch.queue_free()
	
	for i in system.knownRecipies.size():
		var ri = recipyListItemObject.instantiate()
		ri.setUpRecipy(system.knownRecipies[i],i)
		container.add_child(ri)

func exitRecipyBookAnimation():
	container.visible = false
	for ch in container.get_children():
		ch.queue_free()
	$AnimationPlayer.play("close")

func exitRecipyBook():
	system.mainWindow.changeNavVisibility(true)
	$AnimationPlayer.play("close")
	visible = false
