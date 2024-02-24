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

func updateMoneyLabel():
	$Gold.text = str(returnCoinNumber(money))
	$Coin.texture = returnCoinGraphics(money)

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
