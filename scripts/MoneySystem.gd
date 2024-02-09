extends Control

var money : int = 0

func addMoney(value):
	money += value
	$Gold.text = str(money)
