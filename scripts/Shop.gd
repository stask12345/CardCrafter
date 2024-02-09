extends AreaLocation

func exchageCardIntoCoins(cardData : card):
	var listOfCoins = []
	var coinValue = cardData.value
	
	while coinValue > 10:
		coinValue -= 10
		listOfCoins.append(10)
	
	while coinValue >= 1:
		coinValue -= 1
		listOfCoins.append(1)
	
	return listOfCoins

func cardArrived(c):
	c.z_index = -10
	c.cardDestroyerAnimation()
	$Shop/AnimationPlayer.play("idle")

func endAnimation(c : card):
	monetizeCard(c)
	if $requestingSlot.get_child_count() == 2:
		$Shop/cardDestroyer.rotation_degrees = 0
		$Shop/AnimationPlayer.stop()

var coinObject = preload("res://objects/Utility/Coin.tscn")
@onready var markerPosition : Vector2 = $PositionMarker.global_position
func monetizeCard(c : card):
	var listOfCoins = exchageCardIntoCoins(c)
	for l in listOfCoins:
		var coin = coinObject.instantiate()
		coin.value = l
		coin.global_position = markerPosition
		coin.global_position.x += 45
		coin.global_position.x -= randi()%90
		add_child(coin)
		var strength = 2
		var x = coin.global_position.x + ((coin.global_position.x - markerPosition.x) * strength)
		var y = coin.global_position.y + 50 + randi()%50
		coin.flyToPoint(Vector2(x,y),true)
