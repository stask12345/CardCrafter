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
	
	if packageIndex == 0:
		$FreeLabel.visible = true
		$Buy.visible = true
		$NotEnoughtLabel.visible = false
	else:
		if !checkIfCanBuy():
			$Buy.visible = false
			$NotEnoughtLabel.visible = true
		else:
			$Buy.visible = true
			$NotEnoughtLabel.visible = false

func showCost():
	if packageIndex == 0:
		#$FreeLabel.visible = true
		$CostContainer.visible = false
	else:
		$FreeLabel.visible = false
		
		$CostContainer/item5Money/Cost.text = str(system.moneySystemNode.returnCoinNumber(packageList[packageIndex].costMoney))
		$CostContainer/item5Money/Image.texture = system.moneySystemNode.returnCoinGraphics(packageList[packageIndex].costMoney)
		
		for i in 4:
			if i < packageList[packageIndex].costResources.size():
				$CostContainer.get_child(i+1).get_node("Cost").text = str(packageList[packageIndex].costResourcesQuantity[i]) + " x " + packageList[packageIndex].costResources[i].cardName
				$CostContainer.get_child(i+1).get_node("Image").texture = packageList[packageIndex].costResources[i].image
				$CostContainer.get_child(i+1).visible = true
			else:
				$CostContainer.get_child(i+1).visible = false
		
		$CostContainer.visible = true

func showShopMenu():
	visible = true
	updateShopMenu()

func tryToBuyPackages():
	if checkIfCanBuy():
		for i in cardsToUse.size():
			cardsToUse[i].use(quantityToUse[i])
		
		
		buyPackages()

var cardsToUse = [] #for better optimalization
var quantityToUse = []
func checkIfCanBuy():
	cardsToUse.clear()
	quantityToUse.clear()
	
	if system.moneySystemNode.money < packageList[packageIndex].costMoney:
		return false
	
	for i in packageList[packageIndex].costResources.size():
		var playerCard = system.checkIfHaveCard(packageList[packageIndex].costResources[i])
		if !playerCard:
			return false
		else:
			if playerCard.quantity < packageList[packageIndex].costResourcesQuantity[i]:
				return false
			cardsToUse.append(playerCard)
			quantityToUse.append(packageList[packageIndex].costResourcesQuantity[i])
	return true

func buyPackages():
	if packageList[packageIndex].costMoney != 0:
		system.moneySystemNode.modifyMoneyWithAnim(-packageList[packageIndex].costMoney)
	
	var boughtPackage = $"../Package"
	boughtPackage.updatePackage($PackageList.get_child(packageIndex).get_child(0).texture,packageList[packageIndex])
	boughtPackage.visible = true
	
	$"../..".changeNavVisibility(true)
	visible = false

func exitShopMenu():
	$"../AddButton".visible = true
	$"../..".changeNavVisibility(true)
	visible = false
