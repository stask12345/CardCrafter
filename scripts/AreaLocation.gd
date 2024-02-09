extends Control
class_name AreaLocation

var actionOnAddingCard = false #fires just after player uses card
@onready var system : controlSystem = get_node("/root/MainScene")

func cardAdded(c : card = null): #Fires when card arrives at requesting field
	pass

func cardDeleted():
	pass

func cardCollectedFromOutput():
	pass
