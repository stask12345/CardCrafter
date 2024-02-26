extends Control

var scriptToReturn : Node

func _ready():
	$YesButton.connect("pressed",func(): sendAnswer(true))
	$NoButton.connect("pressed",func(): sendAnswer(false))

var moneyCost : int = 0
func checkPlayerDecision(script, text, moneyCostTem = 0):
	moneyCost = moneyCostTem
	scriptToReturn = script
	$RichTextLabel.text = text
	
	var system : controlSystem = get_node("/root/MainScene")
	if moneyCost != 0:
		$MoneyCost/Cost.text = str(system.moneySystemNode.returnCoinNumber(moneyCost))
		$MoneyCost/Cost/Coin1b.texture = system.moneySystemNode.returnCoinGraphics(moneyCost)
		$MoneyCost.visible = true
	
	visible = true

func sendAnswer(answer):
	if answer and moneyCost != 0:
		var system : controlSystem = get_node("/root/MainScene")
		if system.moneySystemNode.money >= moneyCost:
			system.moneySystemNode.modifyMoneyWithAnim(-moneyCost)
		else:
			var t = get_tree().create_tween()
			t.tween_property($MoneyCost/Cost,"self_modulate",Color(1,0,0),0.2)
			t.tween_property($MoneyCost/Cost,"self_modulate",Color(1,1,1),0.2)
			
			var t1 = get_tree().create_tween()
			t1.tween_property($MoneyCost/Label,"self_modulate",Color(1,0,0),0.2)
			t1.tween_property($MoneyCost/Label,"self_modulate",Color(1,1,1),0.2)
			return
	
	$MoneyCost.visible = false
	scriptToReturn.playerDecision(answer)
	visible = false
	moneyCost = 0

