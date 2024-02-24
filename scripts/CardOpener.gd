extends AreaLocation

func _ready():
	$AddButton.connect("pressed",showShopMenu)

func showShopMenu():
	$AddButton.visible = false
	$"..".changeNavVisibility(false)
	$ShopMenu.showShopMenu()
