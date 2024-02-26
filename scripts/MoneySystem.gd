extends Control
class_name moneySystem

@export var bronzeCoin : Texture
@export var silverCoin : Texture
@export var goldenCoin : Texture
var money : int = 0

func addMoney(value):
	money += value
	updateMoneyLabel()

func spendMoney(value):
	money -= value
	updateMoneyLabel()

func updateMoneyLabel(customValue = 0):
	var value
	if customValue != 0:
		value = customValue
	else:
		value = money
	
	$Gold.text = str(returnCoinNumber(value))
	$Coin.texture = returnCoinGraphics(value)

func modifyMoneyWithAnim(value,dontChange = false): #dontChange for delay in quest room
	var previousMoneyValue
	if !dontChange:
		previousMoneyValue = money
		money += value
	else:
		previousMoneyValue = money - value
	
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	
	t.tween_method(updateMoneyLabel,previousMoneyValue,money,2)
	var newColor = Color(0.3,0.8,0.3)
	if value < 0:
		newColor = Color(0.8,0.3,0.3)
	t.parallel().tween_property($Gold,"self_modulate",newColor,1)
	t.parallel().chain().tween_property($Gold,"self_modulate",Color(1,1,1),0.5)

func returnCoinGraphics(amount):
	if amount < 100:
		return bronzeCoin
	else:
		if amount < 10000:
			return silverCoin
		else:
			return goldenCoin

func returnCoinNumber(amount : float):
	while amount >= 100:
		amount = amount / 100
	return amount
