extends Control

var packageIndex = 0
@export var packageList : Array[package]
@export var costList : Array[recipy]
@onready var system = get_node("/root/MainScene")

func _ready():
	$Exit.connect("pressed",exitShopMenu)
	$Buy.connect("pressed",tryToBuyPackages)
	$ArrowLeft/Button.connect("pressed",func(): movePackageShop(-1))
	$ArrowRight/Button.connect("pressed",func(): movePackageShop(1))
	updateShopMenu()

func movePackageShop(direction):
	packageIndex += direction
	if packageIndex < 0:
		packageIndex = 0
		return
	if packageIndex >= packageList.size():
		packageIndex = packageList.size()-1
		return
	
	
	$ArrowRight.visible = false
	$ArrowLeft.visible = false
	$Title.visible = false
	var oldPackage = $PackageList.get_child(packageIndex - direction)
	var newPackage = $PackageList.get_child(packageIndex)
	
	var t = get_tree().create_tween()
	t.tween_property($PackageList,"global_position:x",$PackageList.global_position.x + (direction * -1 * 225), 0.2)
	t.parallel().tween_property(oldPackage,"modulate",Color(0.2,0.2,0.2,1),0.2)
	t.parallel().tween_property(newPackage,"modulate",Color(1,1,1,1),0.2)
	t.tween_callback(updateShopMenu)

func updateShopMenu():
	$Title.text = packageList[packageIndex].packageName
	$Title.visible = true
	
	showCost()
	
	if packageIndex != 0:
		$ArrowLeft.visible = true
	else:
		$ArrowLeft.visible = false
	if packageIndex != packageList.size()-1:
		$ArrowRight.visible = true
	else:
		$ArrowRight.visible = false

func showCost():
	if packageIndex == 0:
		#$FreeLabel.visible = true
		$CostContainer.visible = false
	else:
		$FreeLabel.visible = false
		
		for i in 4:
			if i < costList[packageIndex].resources.size():
				$CostContainer.get_child(i).get_node("Cost").text = str(costList[packageIndex].quantity[i]) + " x " + costList[packageIndex].resources[i].cardName
				$CostContainer.get_child(i).get_node("Image").texture = costList[packageIndex].resources[i].image
				$CostContainer.get_child(i).visible = true
			else:
				$CostContainer.get_child(i).visible = false
		
		$CostContainer.visible = true

func showShopMenu():
	visible = true

func tryToBuyPackages():
	var cardsToUse = [] #for better optimalization
	var quantityToUse = []
	for i in costList[packageIndex].resources.size():
		var playerCard = system.checkIfHaveCard(costList[packageIndex].resources[i])
		if !playerCard:
			return
		else:
			if playerCard.quantity < costList[packageIndex].quantity[i]:
				return
			cardsToUse.append(playerCard)
			quantityToUse.append(costList[packageIndex].quantity[i])
	
	for i in cardsToUse.size():
		cardsToUse[i].use(quantityToUse[i])
	buyPackages()

func buyPackages():
	var boughtPackage = $"../Package"
	boughtPackage.updatePackage($PackageList.get_child(packageIndex).get_child(0).texture,packageList[packageIndex])
	boughtPackage.visible = true
	
	$"../..".changeNavVisibility(true)
	visible = false

func exitShopMenu():
	$"../AddButton".visible = true
	$"../..".changeNavVisibility(true)
	visible = false
