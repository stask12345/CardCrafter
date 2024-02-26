extends ColorRect

#@export var buildingRecipies : Array[recipy]
#@export var buildingsArray : Array[PackedScene] #Moved to MainWindow
@onready var system : controlSystem = get_node("/root/MainScene")

func _ready():
	$ExitButton.connect("pressed",func(): get_parent().hideBuildingShopList())

func updateBuildingShopList():
	
	var rank = system.rank
	
	for ch in $List.get_children():
		ch.queue_free()
	
	for i in system.mainWindow.rankBuildingsArray.size():
		if rank >= i:
			for buildingRec in system.mainWindow.rankBuildingsArray[i]:
				if !system.builded.has(buildingRec):
					addNewListItem(buildingRec)
	
	#if rank >= 1:
		#if !builded.has(buildingRecipies[0]) and !onBuildingList.has(buildingRecipies[0]):
			#addNewListItem(buildingRecipies[0])
			#onBuildingList.append(buildingRecipies[0])

var listItemInstance = preload("res://objects/Utility/BuildingShopItem.tscn")
func addNewListItem(rec):
	var listItem = listItemInstance.instantiate()
	listItem.requiredRecipy = rec
	$List.add_child(listItem)

func build(requiredRecipy):
	$"..".build(requiredRecipy)
