extends AreaLocation

func _ready():
	$BuildButton.connect("pressed",showBuildingShopList)
	$BuildingSite/CancelButton.connect("pressed",decideIfCancel)

func showBuildingShopList():
	$BuildButton.visible = false
	$BuildingShopMenu.updateBuildingShopList()
	$BuildingShopMenu.visible = true
	system.mainWindow.changeNavVisibility(false)

func hideBuildingShopList():
	$BuildButton.visible = true
	$BuildingShopMenu.visible = false
	system.mainWindow.changeNavVisibility(true)

func build(rec : recipy):
	$BuildingShopMenu.visible = false
	$BuildButton.visible = false
	$BuildingSite.visible = true
	$BuildingSite.setUpBuildingSite(rec)
	system.mainWindow.changeNavVisibility(true)

func buildingCompleted():
	system.builded.append($BuildingSite.buildingRecipy)
	system.mainWindow.changeNavVisibility(false)
	var cloudsInstance = load("res://objects/Utility/Clouds.tscn")
	var clouds = cloudsInstance.instantiate()
	get_node("/root/MainScene").add_child(clouds)
	clouds.get_node("AnimationPlayer").play("built")
	await get_tree().create_timer(1.5).timeout
	destroyEmptyLocation()

func decideIfCancel():
	system.checkPlayerDecision(self,"[font_size=50][center]Cancel building?[/center][/font_size]\n[font_size=30][center][color=red]All resources will be lost.[/color][/center][/font_size]")

func playerDecision(answer):
	if answer:
		cancelBuilding()

func cancelBuilding():
	$BuildButton.visible = true
	$BuildingSite.visible = false

func destroyEmptyLocation():
	var newBuildingInstance : PackedScene = $BuildingSite.buildingRecipy.customOutputObject
	get_parent().addNewLocation(newBuildingInstance,true)
	system.mainWindow.changeNavVisibility(true)
	system.mainWindow.addNewEmptyLocation()
	queue_free()
