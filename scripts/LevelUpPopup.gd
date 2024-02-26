extends Control

var enabledExit = false

func _ready():
	$ExitButton.connect("pressed",exitRankUpAnimation)

func enableExit():
	enabledExit = true

func exitRankUpAnimation():
	if enabledExit:
		get_node("/root/MainScene").mainWindow.changeNavVisibility(true)
		$AnimationPlayer.play("close")
		get_node("/root/MainScene").moneySystemNode.modifyMoneyWithAnim(get_node("/root/MainScene/MainWindow/QuestRoom").rankGoldRewards[get_node("/root/MainScene").rank-1],true)
