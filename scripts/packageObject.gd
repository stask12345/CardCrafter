extends Control

@export var currentPackage : package
@export var packageSize = 4

func _ready():
	$Button.connect("pressed",openPackage)

func updatePackage(packageTexture, newPackage):
	$Image.texture = packageTexture
	currentPackage = newPackage

func openPackage():
	print("open")
	var cardInstance = preload("res://objects/InteractiveCard.tscn")
	for i in packageSize:
		var c : interactiveCard = cardInstance.instantiate()
		c.cardData = currentPackage.getRandomCard()
		
		get_node("/root/MainScene").add_child(c)
		var cardPosition = global_position
		if randi()%2 == 0:
			cardPosition.x += (30 + randi()%75)
		else:
			cardPosition.x -= (30 + randi()%75)
		if randi()%2 == 0:
			cardPosition.y += (30 + randi()%150)
		else:
			cardPosition.y -= (30 + randi()%150)
		c.global_position = cardPosition
		c.call_deferred("openPackageAnimation",global_position)
	set_deferred("visible",false)
	$"../AddButton".set_deferred("visible",true)

