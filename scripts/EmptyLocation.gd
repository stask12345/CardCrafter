extends Control

@onready var system = get_node("/root/MainScene")

func _ready():
	$BuildButton.connect("pressed",showBuildingShopList)
	$BuildingSite/CancelButton.connect("pressed",decideIfCancel)

func showBuildingShopList():
	$BuildButton.visible = false
	$BuildingShopMenu.updateBuildingShopList()
	$BuildingShopMenu.visible = true

func hideBuildingShopList():
	$BuildButton.visible = true
	$BuildingShopMenu.visible = false

func build(rec : recipy):
	$BuildingShopMenu.visible = false
	$BuildButton.visible = false
	$BuildingSite.visible = true
	$BuildingSite.setUpBuildingSite(rec)

func buildingCompleted():
	var newBuildingInstance : PackedScene = $BuildingShopMenu.buildingsArray[$BuildingShopMenu.buildingRecipies.find($BuildingSite.buildingRecipy)]
	get_parent().addNewLocation(newBuildingInstance,true)
	queue_free()

func decideIfCancel():
	system.checkPlayerDecision(self,"Cancel building?\nAll resources will be lost.")

func playerDecision(answer):
	if answer:
		cancelBuilding()

func cancelBuilding():
	$BuildButton.visible = true
	$BuildingSite.visible = false

