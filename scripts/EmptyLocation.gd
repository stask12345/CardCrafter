extends Control

func _ready():
	$BuildButton.connect("pressed",showBuildingShopList)

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
	var newBuildingInstance : PackedScene = $BuildingShopMenu.buildingsArray[$BuildingShopMenu.buildingRecipies.find($BuildingSite.neededRecipy)]
	get_parent().addNewLocation(newBuildingInstance,true)
	queue_free()
