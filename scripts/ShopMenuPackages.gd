extends Control

var packageIndex = 0
@export var packageList : Array[package]

func _ready():
	$Exit.connect("pressed",exitShopMenu)
	$Buy.connect("pressed",buyPackages)
	$ArrowLeft/Button.connect("pressed",func(): movePackageShop(-1))
	$ArrowRight/Button.connect("pressed",func(): movePackageShop(1))

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
	t.tween_property($PackageList,"global_position:x",$PackageList.global_position.x + (direction * -1 * 250), 0.2)
	t.parallel().tween_property(oldPackage,"modulate",Color(0.2,0.2,0.2,1),0.2)
	t.parallel().tween_property(newPackage,"modulate",Color(1,1,1,1),0.2)
	t.tween_callback(updateShopMenu)

func updateShopMenu():
	$Title.text = packageList[packageIndex].packageName
	$Title.visible = true
	$ArrowRight.visible = true
	$ArrowLeft.visible = true

func showShopMenu():
	visible = true

func buyPackages():
	var boughtPackage = $"../Package"
	boughtPackage.updatePackage($PackageList.get_child(packageIndex).texture,packageList[packageIndex])
	boughtPackage.visible = true
	
	$"../..".changeNavVisibility(true)
	visible = false

func exitShopMenu():
	$"../AddButton".visible = true
	$"../..".changeNavVisibility(true)
	visible = false
