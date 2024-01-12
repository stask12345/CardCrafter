extends ColorRect

@export var buildingRecipies : Array[recipy]
@export var buildingsArray : Array[PackedScene]
var builded : Array[recipy]
var onBuildingList : Array[recipy]
@onready var system = get_node("/root/MainScene")

func _ready():
	$ExitButton.connect("pressed",func(): get_parent().hideBuildingShopList())

func updateBuildingShopList():
	var rank = system.rank
	
	if rank >= 2:
		if !builded.has(buildingRecipies[0]) and !onBuildingList.has(buildingRecipies[0]):
			addNewListItem(buildingRecipies[0])
			onBuildingList.append(buildingRecipies[0])

var listItemInstance = preload("res://objects/BuildingShopItem.tscn")
func addNewListItem(rec):
	var listItem = listItemInstance.instantiate()
	listItem.requiredRecipy = rec
	$List.add_child(listItem)

func build(requiredRecipy):
	$"..".build(requiredRecipy)
